//
//  CategoryViewController.swift
//  Todoey
//
//  Created by CASE on 4/10/19.
//  Copyright © 2019 CASE. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories : Results<Category>?

    
    var textfield = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadData()
    }
    
    //MARK:- TABLE DATA SOURCE METHODS
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        print("\(String(describing: cell.textLabel?.text))")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return categories?.count ?? 1
         
    }
   
    
    //MARK:- TABLE DELEGATE METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // itemArray[indexPath.row].done =  !itemArray[indexPath.row].done
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    //MARK:- IB ACTIONS METHODS
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add New To Do List Category", message: "Add Category", preferredStyle: .alert)
        
        alert.addTextField { (field) in
            
            field.placeholder = "Create New Category"
            
            self.textfield = field
        }
        
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = self.textfield.text!
            // newCategory.done = false
            
            
            self.saveData(newCategory)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- DATA MANIPULATION METHODS
    
    func saveData(_ category:Category){
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data: \(error)")
        }
       
        self.tableView.reloadData()
    }
    
    func loadData(){
        
        categories = realm.objects(Category.self)
     
        tableView.reloadData()
    }
    
}


