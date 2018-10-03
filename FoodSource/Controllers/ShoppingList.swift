//
//  ShoppingList.swift
//  FoodSource
//
//  Created by Dina Deng on 4/29/18.
//  Copyright © 2018 DinaStudent. All rights reserved.
//
/*
 User is able to create a personal shopping list.
 */

import UIKit

class ShoppingList: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate{
    
    var shoppingItems: [String] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemTextField: UITextField!
    
    //    var savedItems: [String]
    
    func textFieldEdit(itemTextField: UITextField) {
        itemTextField.text = ""
    }
    
    @IBAction func addItem(sender: UIButton){
        let itemName = itemTextField?.text
        shoppingItems.append(itemName!)
        
        tableView.reloadData()
        itemTextField.resignFirstResponder()
        
        UserDefaults.standard.set(shoppingItems, forKey: "SavedItems")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let savedItems = UserDefaults.standard.object(forKey: "SavedItems")
        
        if savedItems != nil {
            shoppingItems = savedItems as! [String]
        }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let name = shoppingItems[indexPath.row]
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // if swipe is a delete
        if editingStyle == UITableViewCellEditingStyle.delete{
            shoppingItems.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
    }
    
}













