//
//  CategoriesViewController.swift
//  ToDo
//
//  Created by Ahmed Abdelkarim on 26/11/2021.
//

import UIKit

class CategoriesViewController: UITableViewController {
    //MARK: - Outlets
    
    
    //MARK: - Properties
    var categories = [Category]()
    let database = Database.reference
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let categories = database.getCategories() {
            self.categories = categories
        }
    }

    //MARK: - Actions
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        var categoryTextField: UITextField?
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            if let categoryName = categoryTextField?.text {
                if self.database.addCategory(name: categoryName) {
                    self.categories.append(Category(name: categoryName))
                    self.tableView.reloadData()
                }
            }
        }))
        
        alert.addTextField(configurationHandler: { textField in
            categoryTextField = textField
            textField.placeholder = "Category name"
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TodoListViewController
        
        if let selectedIndex = tableView.indexPathForSelectedRow {
            vc.selectedCategoryIndex = selectedIndex.row
        }
    }
}

//MARK: - UITableViewDataSource
extension CategoriesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")!
        
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CategoriesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { (action, view, nil) in
            let deleted = self.database.deleteCategory(at: indexPath.row)
            
            if deleted {
                self.categories.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
        
        delete.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
}
