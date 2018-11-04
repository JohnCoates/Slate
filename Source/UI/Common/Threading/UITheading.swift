//
//  UITheading
//  Created on 11/4/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

class MainThread {
    static func get<T>(execute: () -> T) -> T {
        if Thread.current.isMainThread {
            return execute()
        } else {
            var valueMaybe: T?
            DispatchQueue.main.sync {
                valueMaybe = execute()
            }
            guard let value = valueMaybe else {
                fatalError("Missing value in MainThread.get")
            }
            return value
        }
    }
    
    static func sync(execute: () -> ()) {
        if Thread.current.isMainThread {
            execute()
        } else {
            DispatchQueue.main.sync(execute: execute)
        }
    }
}
