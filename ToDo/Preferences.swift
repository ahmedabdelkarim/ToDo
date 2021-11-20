//
//  Preferences.swift
//  ToDo
//
//  Created by Ahmed Abdelkarim on 20/11/2021.
//

import Foundation

class Preferences {
    static var todoItems: [String]? {
        get {
            return UserDefaults.standard.value(forKey: "TodoItems") as? [String]
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "TodoItems")
        }
    }
    
    
}
