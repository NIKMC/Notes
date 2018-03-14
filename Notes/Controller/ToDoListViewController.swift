//
//  ViewController.swift
//  Notes
//
//  Created by Иван Никитин on 18/02/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class ToDoListViewController: SwipeTableViewController {

//    MARK: - array with type for Realm
    var todoItems : Results<Item>?
    
    var realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    //MARK: - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
//                    realm.delete(item)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

        
    }
    //MARK: - longpressed item
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            let alert = UIAlertController(title: "Rename Item", message: "", preferredStyle: .alert)
            
            if let index = self.tableView.indexPathForRow(at: touchPoint)  {
                
                // your code here, get the row for the indexPath or do whatever you want
                var textField = UITextField()
                let action = UIAlertAction(title: "Rename", style: .default) { (action) in
                    //what will happen once user clicks the Add Iten Button on UIAlert
                    print("Success")
                    if textField.text != nil {
                        if let item = self.todoItems?[index.row] {
                            do {
                                try self.realm.write {
                                    item.title = textField.text!
                                }
                            } catch {
                                print("Error updatinf item, \(error)")
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
                alert.addTextField { (alertTextField) in
                    alertTextField.text = self.todoItems?[index.row].title ?? "None"
                    textField = alertTextField
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Notes Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks the Add Iten Button on UIAlert
            print("Success")
            if textField.text != nil {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateTime = Date()
                            currentCategory.items.append(newItem)
                            self.realm.add(newItem)
                        }
                    } catch {
                        print("Error save items \(error)")
                    }
                    self.tableView.reloadData()
                }
            }
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            print("cancel")
        }
        alert.addAction(action)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let curentItem = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(curentItem)
                }
            } catch {
                print("Error deletion category, \(error)")
            }
        }
    }
    
    
    
//     MARK: - Function save items for Realm
    func save(with item:Item) {
    
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error save items \(error)")
        }
            tableView.reloadData()
    
        }
    
      //    MARK: - function loading items from Realm
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}
// MARK: SearchBar methods
extension ToDoListViewController: UISearchBarDelegate {
   // MARK: searchBarSearchButtonClicked methods for Realm

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateTime", ascending: true)
        tableView.reloadData()
    }
    
      // MARK: searchBar methods for Realm
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}



