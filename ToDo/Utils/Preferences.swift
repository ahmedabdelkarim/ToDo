//
//  Preferences.swift
//  ToDo
//
//  Created by Ahmed Abdelkarim on 20/11/2021.
//

import Foundation

class Preferences {
    static var todoItems: [TodoItem]? {
        get {
            guard let data = UserDefaults.standard.value(forKey: "TodoItems") as? Data else {
                return nil
            }
            
            do {
                let items = try JSONDecoder().decode([TodoItem].self, from: data)
                
                return items
            }
            catch {
                return nil
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.setValue(data, forKey: "TodoItems")
            }
            catch {  }
        }
    }
    
}
