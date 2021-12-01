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
    let database = Database.reference
    var selectedCategoryIndex: Int = -1
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        if let todoItems = Preferences.todoItems {
        //            self.items = todoItems
        //        }
        
        //        if let todoItems = Documents.getTodoItems() {
        //            self.items = todoItems
        //        }
        
        if let items = database.getTodoItems(for: selectedCategoryIndex) {
            self.items = items
        }
    }
    
    //MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        var itemTextField: UITextField?
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            if let itemTitle = itemTextField?.text {
                if self.database.addTodoItem(categoryIndex: self.selectedCategoryIndex, title: itemTitle) {
                    self.items.append(TodoItem(title: itemTitle, done : false))
                    self.tableView.reloadData()
                }
                
                //Preferences.todoItems = self.items
                //Documents.saveTodoItems(self.items)
            }
        }))
        
        alert.addTextField(configurationHandler: { textField in
            itemTextField = textField
            textField.placeholder = "Item title"
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
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TodoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //var item = items[indexPath.row]
        
        let newDoneValue = !items[indexPath.row].done
        
        //items[indexPath.row].done = newDoneValue
        
        //Preferences.todoItems = self.items
        //Documents.saveTodoItems(self.items)
        
        let updated = database.updateDoneForTodoItem(atCategory: self.selectedCategoryIndex, at: indexPath.row, with: newDoneValue)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if updated {
            items[indexPath.row].done = newDoneValue
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { (action, view, nil) in
            let deleted = self.database.deleteTodoItem(atCategory: self.selectedCategoryIndex, at: indexPath.row)
            
            if deleted {
                self.items.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
        
        delete.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        
        if let searchResultItems = database.searchTodoItems(for: self.selectedCategoryIndex, forTitle: searchText) {
            self.items = searchResultItems
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            if let todoItems = database.getTodoItems(for: self.selectedCategoryIndex) {
                self.items = todoItems
                
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                    self.tableView.reloadData()
                }
            }
        }
    }
}
