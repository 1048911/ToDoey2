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
   
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        
     
         
        
        loadData()
    }
    
  //MARK:- TableView Delegate Methods

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
       
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
       
        cell.accessoryType = item.done ? .checkmark : .none
        
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
            self.saveData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

//MARK:- Model Manipulation Methods
    
    func saveData(){
        let encoder = PropertyListEncoder()
        
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding array: \(error)")
            
        }
        
        self.tableView.reloadData()
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do { itemArray =  try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding array: \(error)")
            }
        }
        
    }

}

