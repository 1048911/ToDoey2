//
//  ViewController.swift
//  Todoey
//
//  Created by CASE on 3/25/19.
//  Copyright © 2019 CASE. All rights reserved.
//

import UIKit

class TodoeyViewController: UITableViewController {
   
    //MARK: Declare variables and constants here
    
    var textfield = UITextField()
    var itemArray = [Item]()
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     //   if let items = defaults.array(forKey: "TodoListArray") as? [String] {
       //     itemArray = items
       // }
            let newItem = Item()
            newItem.title = "Find Mike"
            itemArray.append(newItem)
       
            let newItem2 = Item()
            newItem2.title = "Find Thomas"
            itemArray.append(newItem2)
        
            let newItem3 = Item()
            newItem3.title = "Find Carl"
            itemArray.append(newItem3)
    }
    
  //MARK:- TableView Delegate Methods

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
  
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New To Do List Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder =
            "Create new item"
            self.textfield = alertTextfield
        }
       
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = self.textfield.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }


    
}

