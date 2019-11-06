//
//  CategoryViewController.swift
//  Todoey
//
//  Created by CASE on 4/10/19.
//  Copyright © 2019 CASE. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories : Results<Category>?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
      
       loadData()
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        let navBarColor : UIColor = FlatWhite()
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
    }
    
 
    
    //MARK:- TABLE DATA SOURCE METHODS
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"

        guard let colorName = categories?[indexPath.row].color else {fatalError("No Category found!") }

            cell.backgroundColor = UIColor(hexString: colorName)
        guard let chosenColor = cell.backgroundColor else {fatalError("Cell has no background color!")}


        cell.textLabel?.textColor = ContrastColorOf(chosenColor, returnFlat: true)


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
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

            var textfield = UITextField()
         
         let alert = UIAlertController(title: "Add New To Do List Category", message: "Add Category", preferredStyle: .alert)


         
         let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
             let newCategory = Category()
             newCategory.name = textfield.text!
             let arrayColors : [UIColor] = [FlatLime(), FlatOrange(), FlatSkyBlue(), FlatMint(), FlatWatermelon()]
             if let randomColor = UIColor.init(randomColorIn: arrayColors){
                 newCategory.color = randomColor.hexValue()
             }
             
             // newCategory.done = false
             self.saveData(newCategory)
         }
            alert.addAction(action)
        
         alert.addTextField { (field) in
             textfield = field
                    field.placeholder = "Create New Category"
                }
         
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
        
        categories = realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)
     
        tableView.reloadData()
    }
    
    //MARK:- DATA DELETION METHODS
    
    override func updateData(indexPath: IndexPath) {
                        if let categoryToDelete = self.categories?[indexPath.row] {
                            do {
                                try self.realm.write {
                                    self.realm.delete(categoryToDelete)
                                }
                            } catch {
                                print("Error deleting category: \(error)")
                            }
                        }
    }
    
}



