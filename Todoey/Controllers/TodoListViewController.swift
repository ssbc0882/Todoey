//
//  ViewController.swift
//  Todoey
//
//  Created by Bryan Heshiki on 12/20/17.
//  Copyright © 2017 Bryan Heshiki. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    //collection of item results
    var toDoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        
        didSet{
           
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    
    }
        

    //Mark: Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returns the count if there's item, if not it returns 1 cell- which is "No Items added"
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //tablecells gets resused in the app
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
        
        
        cell.textLabel?.text = item.title
        
            //checks if row has a checkmark or not: item.done = true, .checkmark = false
            //Ternary operator - value = condition ? ValueifTrue : Valueiffalse
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            //if there are no items inside the selected category
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //tableview delegate method - tells delegate row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if the row is not nil
        if let item = toDoItems?[indexPath.row] {
            
            do {
            try realm.write {
             item.done = !item.done
                }
            }catch {
                //if the row is nil
                    print("Error saving done status. \(error)")
                }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //Mark: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//
//            //what will happen once the user clicks the Add button on our UIAlert
//
//            //UI app singleton instance
//
            if let currentCategory = self.selectedCategory {
                
                do {
                    //update realm and commit them
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    //currentCategory will add new items from (newItem = Item())
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new items. \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //Mark - Model Manipulation Methods
    

    func loadItems() {

        //looks at selectedCategory and sorts the list of items(items = List<Item>) inside it by its title in alphabecial order
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
            tableView.reloadData()

}

}

//Mark- search bar methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
           //filtering out our toDoList items
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    
        tableView.reloadData()
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


