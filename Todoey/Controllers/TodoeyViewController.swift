//
//  ViewController.swift
//  Todoey
//
//  Created by CASE on 3/25/19.
//  Copyright © 2019 CASE. All rights reserved.
//

import UIKit
import RealmSwift


class TodoeyViewController: UITableViewController {
    
    //MARK: Declare variables and constants here
    
   let realm = try! Realm()
    var textfield = UITextField()
    var todoItems : Results<Item>?
    
    
    var selectedCategory : Category? {
        didSet {
            loadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //MARK:- TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        }
         else {
            cell.textLabel?.text = "No items added yet"
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      //  todoItems[indexPath.row].done = !todoItems[indexPath.row].done
       
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status: \(error)")
            }
              tableView.reloadData()
        }
        
        
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
            
            if let currentCategory = self.selectedCategory {
           
               
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = self.textfield.text!
                        newItem.done = false
                       newItem.dateCreated = Date()
                        currentCategory.Items.append(newItem)
                      
                    }
                } catch {
                    print("Error saving data: \(error)")
                }
             
            }
                          self.tableView.reloadData()
            
           
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Model Manipulation Methods
    
   
    func loadData() {
        
       todoItems = selectedCategory?.Items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        
        tableView.reloadData()
            
        }
    
    
}

 extension TodoeyViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {

            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

 }




