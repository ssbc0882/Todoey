//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bryan Heshiki on 12/31/17.
//  Copyright © 2017 Bryan Heshiki. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    //Results- collection type of category objects
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   loadCategories()

    
    }
    
    func loadCategories() {
        
        //looks up realm and searches for category objects that belong to Category datatype
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
       //Mark: Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        nil coalescing operator- if categories is nil -we will return 1- one row
       return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //tablecells gets resused in the app
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //if no categories- this message "No categories added yet" will pop up - came from the tableView numberOfRowsInSection. If yes, it will show the indexPath.row.name
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
        //Mark: Tableview Delegate methods
    
    //takes Category to to ToDoListController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController

        //identifies the current row selected
        if  let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    //Mark: Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
        //what happens below is when user clicks the add button
        
        let newCategory = Category()
        newCategory.name = textField.text!
    
        
        self.save(category: newCategory)
    }
    
       alert.addAction(action)
        
    alert.addTextField { (field) in
    
    textField.placeholder = "Add a new category"
    textField = field
    }
    
    present(alert, animated: true, completion: nil)
}

//Mark - Model Manipulation Methods


    func save (category: Category) {
    
    do {
        //use realm.write to commit our changes by adding to our category databse
        try realm.write {
            realm.add(category)
        }
    } catch {
        print("error saving category \(error)")
    }
    self.tableView.reloadData()
    
}

    
}
