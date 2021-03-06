//
//  MealsDetailTableVC.swift
//  FoodSource
//
//  Created by Dina Deng on 4/30/18.
//  Copyright © 2018 DinaStudent. All rights reserved.
//
/*
    Displays the detailed information (Image and link to recipe) of the selected recipe.
    (API returns limited amount of information.)
 */

import UIKit

class MealsDetailTableVC: UITableViewController {
    
    var meal: Meal!
    let IMAGE_SECTION = 0
    let URL_SECTION = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")

        // Create a cell if cant DQ
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        
        // Configure the cell:
        switch indexPath.section{
            case IMAGE_SECTION:
                let url = URL(string: meal.getImage_url())
                let imgData = try? Data(contentsOf: url!)
            
                if imgData != nil{
                    cell?.imageView?.image = UIImage(data:imgData! as Data)
                    cell?.imageView?.center = (cell?.center)!
                }
            case URL_SECTION:
                cell!.textLabel?.text = meal.source_url
                cell!.textLabel?.numberOfLines = 0
                cell!.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            default:
                break
        }

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == IMAGE_SECTION {
            return 230.0
        }
        else{
            return 14.0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        
        switch section{
        case URL_SECTION:
            title = "Recipe Link"
            
        default:
            break
        }
        return title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == URL_SECTION {
            let url = URL(string : meal.getSource_url())
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            
        }
        tableView.deselectRow(at: indexPath, animated: false)
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
