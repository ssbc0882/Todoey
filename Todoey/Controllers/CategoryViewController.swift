//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bryan Heshiki on 12/31/17.
//  Copyright © 2017 Bryan Heshiki. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    
    }
    
       //Mark: Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //tablecells gets resused in the app
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
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
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }

    //Mark: Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
        //what happens below is when user clicks the add button
        
        let newCategory = Category(context: self.context)
        newCategory.name = textField.text!
       
        
        self.categories.append(newCategory)
        
        self.saveCategories()
    }
    
       alert.addAction(action)
        
    alert.addTextField { (field) in
    
    textField.placeholder = "Add a new category"
    textField = field
    }
    
    present(alert, animated: true, completion: nil)
}

//Mark - Model Manipulation Methods

//encoding our  data of a list of items into a plist
func saveCategories () {
    
    do {
        try context.save()
    } catch {
        print("error saving category \(error)")
    }
    self.tableView.reloadData()
    
}

//we decode the data and take out that list of items.
//Categories.fetchrequest() is the default value if the data doesn't return the first value

    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
    
    do {
        categories = try context.fetch(request)
    } catch {
        print("error fetching data \(error)")
    }

        tableView.reloadData()
    }
    
 
    
    

    
    
 
    
}
