//
//  ViewController.swift
//  Todoey
//
//  Created by CASE on 3/25/19.
//  Copyright © 2019 CASE. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoeyViewController: SwipeTableViewController {
    
    //MARK: Declare variables and constants here
    
   let realm = try! Realm()
    var textfield = UITextField()
    var todoItems : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool ) {
            title = selectedCategory?.name
       
        guard let currentColor = selectedCategory?.color else {fatalError("No Color found for current category!")}
   
        
        updateNavBar(hexString: currentColor)
        
  
        
      
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(hexString: "f5f6fa")
        
    }
    
    func updateNavBar(hexString: String){
       

        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColor = UIColor(hexString: hexString) else { fatalError()}
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
        
    }
    
    //MARK:- TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        }
         else {
            cell.textLabel?.text = "No items added yet"
        }
        
        guard let colorName = selectedCategory?.color  else {fatalError("The selected category has no color!")}
            let color = UIColor(hexString: colorName)
            cell.backgroundColor = color?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count))
            
        guard let chosenColor = cell.backgroundColor else {fatalError("Cell has no background color!")}
        
        cell.textLabel?.textColor = ContrastColorOf(chosenColor, returnFlat: true)
        
        
        
        
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
    
    //MARK:- DATA DELETION METHODS
    
    override func updateData(indexPath: IndexPath) {
        if let itemToDelete = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
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




