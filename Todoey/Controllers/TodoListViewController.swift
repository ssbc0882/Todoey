//
//  ViewController.swift
//  Todoey
//
//  Created by Bryan Heshiki on 12/20/17.
//  Copyright © 2017 Bryan Heshiki. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //singelton
    //also where your encodable and decodable data goes to: the saved data is in a plist file
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
            loadItems()
        
    }

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
        //print (itemArray[indexPath.row])
        
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
          
            let newItem = Item()
            newItem.title = textField.text!
            
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
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding itemArray, \(error)")
        }
        self.tableView.reloadData()
        
        }
    
    //we decode the data and take out that list of items
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            //decodes your items
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
                
            }catch {
                print("Error decoding data \(error)")
            }
            
        }
    }
}

