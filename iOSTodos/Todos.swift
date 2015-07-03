//
//  Todos.swift
//  Image Search
//
//  Created by 高橋健太 on 2015/06/18.
//  Copyright (c) 2015年 高橋健太. All rights reserved.
//

import Foundation
import CoreData

class Todos: NSManagedObject {

    @NSManaged var content: String
    
    func validateContent(ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>, error: NSErrorPointer) -> Bool {
        if let content = ioValue.memory as? String {
            if content == "" {
                println("Content is empty...")
                return false
            }
        } else {
            println("Content is nil...")
            return false
        }
        return true
    }
}