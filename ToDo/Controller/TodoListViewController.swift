//
//  TodoListViewController.swift
//  ToDo
//
//  Created by Ahmed Abdelkarim on 20/11/2021.
//

import UIKit

class TodoListViewController: UITableViewController {
    //MARK: - Outlets
    
    
    //MARK: - Properties
    var items = [TodoItem]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todoItems = Preferences.todoItems {
            self.items = todoItems
        }
    }
    
    //MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        var itemTextField: UITextField?
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            if let itemTitle = itemTextField?.text {
                self.items.append(TodoItem(title: itemTitle, done : false))
                self.tableView.reloadData()
                
                Preferences.todoItems = self.items
            }
        }))
        
        alert.addTextField(configurationHandler: { textField in
            itemTextField = textField
            textField.placeholder = "Item name"
        })
        
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - UITableViewDataSource
extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell")!
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text
            = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TodoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //var item = items[indexPath.row]
        
        items[indexPath.row].done = !items[indexPath.row].done
        
        Preferences.todoItems = self.items
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
}
