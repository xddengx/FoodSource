//
//  RecipeTableVC.swift
//  FoodSource
//
//  Created by Dina Deng on 4/24/18.
//  Copyright © 2018 DinaStudent. All rights reserved.
//
/*
    Handles calls to API and returns list of recipes.
 */

import UIKit

class RecipeTableVC: UITableViewController{
    
    var endpoint: URL?
    var meals:[Meal] = []
    let cellID = "mealCell"
    var itemsFav:[String] = []
    
    let BREAKFAST_SECTION = 0
    let LUNCH_SECTION = 1
    let DINNER_SECTION = 2
    let DESSERT_SECTION = 3
    
    func favoriteCell(cell: UITableViewCell){
        // Selected cell
        let selectedCell = tableView.indexPath(for: cell)
     
        let name = meals[(selectedCell?.row)!]
        
        var yesFavorite = name.favorited
        
        meals[(selectedCell?.row)!].favorited = !yesFavorite!
        
        let title = name.title
        self.itemsFav.append(title as! String)
        var favoritedCell = UserDefaults.standard.set(self.itemsFav, forKey: "favorite")

        
        tableView.reloadRows(at: [selectedCell!], with: .fade)
    }
    
    @IBOutlet weak var filter: UISegmentedControl!
    
    @IBAction func filterMeal(_ sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex){
        case BREAKFAST_SECTION:
            endpoint = URL(string: "http://food2fork.com/api/search?key=68d9520c69bdc254d404fe1eb904f9a0&q=breakfast")
            meals.removeAll()
            loadData()
            tableView.reloadData()
        case LUNCH_SECTION:
            endpoint = URL(string: "http://food2fork.com/api/search?key=68d9520c69bdc254d404fe1eb904f9a0&q=lunch")
            meals.removeAll()
            loadData()
            tableView.reloadData()
        case DINNER_SECTION:
            endpoint = URL(string: "http://food2fork.com/api/search?key=68d9520c69bdc254d404fe1eb904f9a0&q=dinner")
            meals.removeAll()
            loadData()
            tableView.reloadData()
        case DESSERT_SECTION:
            endpoint = URL(string: "http://food2fork.com/api/search?key=68d9520c69bdc254d404fe1eb904f9a0&q=desserts")
            meals.removeAll()
            loadData()
            tableView.reloadData()
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // once recipe is clicked, load breakfast recipes
        endpoint = URL(string: "http://food2fork.com/api/search?key=68d9520c69bdc254d404fe1eb904f9a0&q=breakfast")
        loadData()
        
        tableView.register(RecipeCell.self, forCellReuseIdentifier: cellID)
    }
    
    func loadData(){
//        let endpoint = URL(string: "http://food2fork.com/api/search?key=68d9520c69bdc254d404fe1eb904f9a0&q=breakfast")
        
        //fetch synchnorous. won't go any further until it gets the data
        let data = try? Data(contentsOf: endpoint!)
        
        // using swiftJSON
        let session = URLSession.shared
        let loadDataTask = session.dataTask(with: endpoint!) { (data:Data?, response: URLResponse?, error: Error?) in
            if let responseError = error{
                print("Error has occured: \(responseError)")
                // reminder = probably on background thread at this point
            } else if let httpResponse = response as? HTTPURLResponse{
//                print("\(httpResponse)")
                if httpResponse.statusCode != 200{
                    let statusError = NSError(domain: "dina.FoodSource", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey: "HTTP Status code has unexpected value"])
                    // error occured - display an alert or something
                    // reminder = probably on background thread at this point
                } else{
                    // received JSON
                    // create json object
                    let json = try! JSON(data:data!) // do catch would be better
                    // creates a dictionary
                    if let mealName = json["recipes"][2]["title"].string{
                        
                        // get the list of meals
                        if let mealArray = json["recipes"].array{
                            //var breakfasts = [Breakfast]()
                            for mealDict in mealArray{
                                let mName:String? = mealDict["title"].string
                                let mURL:String? = mealDict["source_url"].string
                                let mImage:String? = mealDict["image_url"].string
                                let mFavorited:Bool? = false
                                
                                let m = Meal(title: mName!, source_url: mURL!, image_url: mImage!, favorited: mFavorited!)
                                self.meals.append(m)
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        // starts
        loadDataTask.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RecipeCell

        cell.recipeVC = self
        // Configure the cell...
        let meal = meals[indexPath.row]
        cell.textLabel?.text = meal.title
        cell.accessoryType = .disclosureIndicator

        cell.accessoryView?.tintColor = meal.favorited! ? UIColor.green : .lightGray
    
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = meals[indexPath.row]
        let detailVC = MealsDetailTableVC(style: .grouped)
        
        detailVC.title = meal.title
        
//        cell!.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        detailVC.meal = meal
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
