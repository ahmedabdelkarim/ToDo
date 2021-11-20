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
    var items = [String]()
    
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
            if let item = itemTextField?.text {
                self.items.append(item)
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
        
        cell.textLabel?.text
            = items[indexPath.row]
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TodoListViewController {
    
}
