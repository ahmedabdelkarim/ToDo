//
//  Documents.swift
//  ToDo
//
//  Created by Ahmed Abdelkarim on 20/11/2021.
//

import Foundation

class Documents {
    private static let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func saveTodoItems(_ items: [TodoItem]) {
        let encoder = PropertyListEncoder()
        let todoItemsDocument = documents.appendingPathComponent("TodoItems.plist")
        
        do {
            let data = try encoder.encode(items)
            try data.write(to: todoItemsDocument)
        }
        catch {
            print(error)
        }
    }
    
    static func getTodoItems() -> [TodoItem]? {
        let decoder = PropertyListDecoder()
        let todoItemsDocument = documents.appendingPathComponent("TodoItems.plist")
        
        do {
            let data = try Data(contentsOf: todoItemsDocument)
            return try decoder.decode([TodoItem].self, from: data)
        }
        catch {
            print(error)
            return nil
        }
    }
}
