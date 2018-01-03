//
//  ViewController.swift
//  Todoey
//
//  Created by Bryan Heshiki on 12/20/17.
//  Copyright © 2017 Bryan Heshiki. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        
        didSet{
           
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    
    }
        

    //Mark: Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //tablecells gets resused in the app
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        
        cell.textLabel?.text = item.title
        
        //checks if row has a checkmark or not
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //tableview delegate method - tells delegate row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
//            context.delete(itemArray[indexPath.row])
//            itemArray.remove(at: indexPath.row)
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //Mark: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the Add button on our UIAlert
          
            //UI app singleton instance
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            //if item is related to the selected category
            newItem.parentCategory = self.selectedCategory
            
           self.itemArray.append(newItem)
            
            self.saveItems()
        }
           
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //Mark - Model Manipulation Methods
    
    //encoding our  data of a list of items into a plist
    func saveItems () {
        
        
        
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
        
        }
    
    //we decode the data and take out that list of items.
    //Item.fetchrequest() is the default value if the data doesn't return the first value
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("error fetching data \(error)")
        }
    }
    
    
}

//Mark- search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text! )
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            //ask dispatch to get the main queue
            DispatchQueue.main.async {
                
                //no longer the thing being used. Gets rid of keyboard
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
