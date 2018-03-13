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

class CategoryViewController: UITableViewController {
//    MARK: - array with type for CoreData
//    var categoryArray = [Category]()
//    MARK: - array with type for Realm
    var categories: Results<Category>?
//    MARK: - context for CoreData
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        load()
        //    MARK: - loading data from CoreData
//        loadCategories()
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        
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
    
    
    //MARK: - Add New Categories
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text != nil {
                //TODO: - initialize for CoreData
//                let newCategory = Category(context: self.context)
                let newCategory = Category()
                newCategory.name = textField.text!

//                self.categoryArray.append(newCategory)
//                self.saveCategories()
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
    //MARK: -  function loading data from CoreData
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetch categories \(error)")
//        }
//        tableView.reloadData()
//    }
//    MARK: -  function loading data from Realm
    func load() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
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
//  MARK: - function save data for CoreData
//    func saveCategories(){
//        do {
//            try context.save()
//        } catch {
//            print("Error save categories \(error)")
//        }
//        tableView.reloadData()
//    }
    
    //MARK: - TableView Manipulation Methods
   
}
