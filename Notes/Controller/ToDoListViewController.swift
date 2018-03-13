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

class ToDoListViewController: UITableViewController {
//    MARK: - array with type for CoreData
//    var itemArray = [Item]()
//    MARK: - array with type for Realm
    var todoItems : Results<Item>?
    
    var realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
//    user default preference simple way to store array or some value
//    let defaults = UserDefaults.standard
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //    MARK: - context for CoreData
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    //MARK: - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
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
        //Using for CoreData
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        
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
                        
//                        self.todoItems?[index.row].title = textField.text!
//                        simple way how to save changed values in preference
//                        self.defaults.setValue(self.itemArray, forKey: "ToDoListArray")
//                        self.saveItems()
                        self.tableView.reloadData()
                    }
                }
                alert.addTextField{ (alertTextField) in
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
//                TODO: - initialise data for CoreData
//                let newItem = Item(context: self.context)
//                newItem.title = textField.text!
//                newItem.done = false
//                newItem.parentCategory = self.selectedCategory
//                self.itemArray.append(newItem)
//                self.defaults.setValue(self.itemArray, forKey: "ToDoListArray")
//                self.saveItems()

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
    
    // MARK: - Model Manupulation Methods
    // MARK: - Function save items for CoreData
//    func saveItems() {
//
//        do{
//            try context.save()
//        } catch{
//            print("Error saving context, \(error)")
//        }
//        tableView.reloadData()
//
//    }
    
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
    
    
//    MARK: - function loading items from CoreData
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionaPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionaPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching ata from context \(error)")
//        }
//        tableView.reloadData()
//    }
    //    MARK: - function loading items from Realm
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}
// MARK: SearchBar methods
extension ToDoListViewController: UISearchBarDelegate {
// MARK: searchBarSearchButtonClicked methods for CoreDara
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        //CoreData
////        loadItems(with: request, predicate: predicate)
//    }
    // MARK: searchBarSearchButtonClicked methods for Realm

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateTime", ascending: true)
        tableView.reloadData()
    }
    
    // MARK: searchBar methods for CoreData
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            //CoreData
//            //            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
    
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

