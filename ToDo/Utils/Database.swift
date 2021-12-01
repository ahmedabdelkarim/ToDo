//
//  Database.swift
//  ToDo
//
//  Created by Ahmed Abdelkarim on 25/11/2021.
//

import Foundation
import CoreData

class Database {
    //MARK: - Singleton
    static let reference = Database()
    
    private init() {}
    
    //MARK: - Properties
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    //MARK: - Methods
    
    func addCategory(name: String) -> Bool {
        let category = CategoryEntity(context: context)
        category.name = name
        
        return saveContext()
    }
    
    func getCategories() -> [Category]? {
        let categories = fetchCategories()
        return categories
    }
    
    func deleteCategory(at index: Int) -> Bool {
        if let item = fetchCategory(at: index) {
            context.delete(item)
            
            return saveContext()
        }
        else {
            return false
        }
    }
    
    func addTodoItem(categoryIndex: Int, title: String) -> Bool {
        let item = TodoItemEntity(context: context)
        item.category = fetchCategory(at: categoryIndex)
        item.title = title
        item.done = false
        
        return saveContext()
    }
    
    func getTodoItems(for categoryIndex: Int) -> [TodoItem]? {
        let items = fetchTodoItems(for: categoryIndex)
        return items
    }
    
    func searchTodoItems(for categoryIndex: Int, forTitle title: String) -> [TodoItem]? {
        let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", title)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let items = fetchTodoItems(for: categoryIndex, with: request)
        return items
    }
    
    func updateDoneForTodoItem(atCategory categoryIndex: Int, at index: Int, with done: Bool) -> Bool {
        if let item = fetchTodoItem(atCategory: categoryIndex, at: index) {
            item.done = done
            
            return saveContext()
        }
        else {
            return false
        }
    }
    
    func deleteTodoItem(atCategory categoryIndex: Int, at index: Int) -> Bool {
        if let item = fetchTodoItem(atCategory: categoryIndex, at: index) {
            context.delete(item)
            
            return saveContext()
        }
        else {
            return false
        }
    }
    
    //MARK: - Private Methods
    private func fetchCategories(with request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()) -> [Category]? {
        do {
            let categoryEntities = try context.fetch(request)
            
            let categories = categoryEntities.map {
                Category(name: $0.name!)
            }
            
            return categories
        }
        catch {
            print(error)
            return nil
        }
    }
    
    private func fetchTodoItems(for categoryIndex: Int, with request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()) -> [TodoItem]? {
        do {
            guard let category = fetchCategory(at: categoryIndex) else {
                return nil
            }
            
            let categoryPredicate = NSPredicate(format: "category.name == %@", category.name!)
            
            if let predicate = request.predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, categoryPredicate])
            }
            else {
                request.predicate = categoryPredicate
            }
            
            let itemEntities = try context.fetch(request)
            
            let items = itemEntities.map {
                TodoItem(title: $0.title!, done: $0.done)
            }
            
            return items
        }
        catch {
            print(error)
            return nil
        }
    }
    
    private func fetchTodoItem(atCategory categoryIndex: Int, at index: Int) -> TodoItemEntity? {
        guard let category = fetchCategory(at: categoryIndex) else {
            return nil
        }
        
        let categoryPredicate = NSPredicate(format: "category.name == %@", category.name!)
        
        let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        request.predicate = categoryPredicate
        request.fetchOffset = index
        request.fetchLimit = 1
        
        do {
            let item = try context.fetch(request).first
            return item
        }
        catch {
            print(error)
            return nil
        }
    }
    
    private func fetchCategory(at index: Int) -> CategoryEntity? {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.fetchOffset = index
        request.fetchLimit = 1
        
        do {
            let item = try context.fetch(request).first
            return item
        }
        catch {
            print(error)
            return nil
        }
    }
    
    private func saveContext () -> Bool {
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                let error = error as NSError
                print("Unresolved error \(error), \(error.userInfo)")
                return false
            }
        }
        
        return false
    }
}
