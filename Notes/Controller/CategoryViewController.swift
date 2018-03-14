//
//  CategoryViewController.swift
//  Notes
//
//  Created by Иван Никитин on 08/03/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

//    MARK: - array with type for Realm
    var categories: Results<Category>?
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        load()
        tableView.separatorStyle = .none
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColour = UIColor(hexString: category.color) else {fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ToDoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    //MARK: - longpressed item
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            let alert = UIAlertController(title: "Rename Categoty", message: "", preferredStyle: .alert)
            
            if let index = self.tableView.indexPathForRow(at: touchPoint)  {
                
                // your code here, get the row for the indexPath or do whatever you want
                var textField = UITextField()
                let action = UIAlertAction(title: "Rename", style: .default) { (action) in
                    //what will happen once user clicks the Add Iten Button on UIAlert
                    if textField.text != nil {
                        if let currentCategory = self.categories?[index.row] {
                            do {
                                try self.realm.write {
                                    currentCategory.name = textField.text!
                                }
                            } catch {
                                print("Error updatinf item, \(error)")
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
                alert.addTextField { (alertTextField) in
                    alertTextField.text = self.categories?[index.row].name ?? "None"
                    textField = alertTextField
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text != nil {

                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat.hexValue()
                self.save(with: newCategory)
            }
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            print("cancel")
        }
        alert.addTextField{ (field) in
            textField = field
            field.placeholder = "Create new category"
            
        }
        alert.addAction(action)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }

    //    MARK: -  function loading data from Realm
    func load() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deletion category, \(error)")
            }
        }
    }
    
    //MARK: - function save data in Realm
    func save(with category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error save categories \(error)")
        }
        tableView.reloadData()
    }
}
