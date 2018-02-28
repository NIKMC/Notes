//
//  ViewController.swift
//  Notes
//
//  Created by Иван Никитин on 18/02/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

//    var itemArray = ["Note1", "Note2", "Note3","Note11", "Note12", "Note13","Note21", "Note22", "Note23","Note31", "Note32", "Note33","Note41", "Note42", "Note43","Note51", "Note52", "Note53","Note61", "Note62", "Note63"]
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for i in 0...30 {
            let item = Item()
            item.title = "note \(i)"
            itemArray.append(item)
        }
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
//        }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    //MARK - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        
    }
    //MARK - longpressed item
    
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
                        self.itemArray[index.row].title = textField.text!
                        self.defaults.setValue(self.itemArray, forKey: "ToDoListArray")
                        self.tableView.reloadData()
                    }
                }
                alert.addTextField{ (alertTextField) in
                    alertTextField.text = self.itemArray[index.row].title
                    textField = alertTextField
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Notes Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks the Add Iten Button on UIAlert
            print("Success")
            if textField.text != nil {
                let newItem = Item()
                newItem.title = textField.text!
            
                self.itemArray.append(newItem)
                self.defaults.setValue(self.itemArray, forKey: "ToDoListArray")
                self.tableView.reloadData()
            }
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

