//
//  NSManagedObjectContext+Observers.swift
//  Slate
//
//  Created by John Coates on 6/12/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

struct ObjectsDidChangeNotification {
    
    private let notification: Notification
    
    static let name = NSNotification.Name.NSManagedObjectContextObjectsDidChange
    
    init(notification: Notification) {
        guard notification.name == ObjectsDidChangeNotification.name else {
            fatalError("Incorrect notification name")
        }
        
        self.notification = notification
    }
    
    var insertedObjects: Set<NSManagedObject> {
        return objects(forKey: NSInsertedObjectsKey)
    }
    
    var updatedObjects: Set<NSManagedObject> {
        return objects(forKey: NSUpdatedObjectsKey)
    }
    
    var deletedObjects: Set<NSManagedObject> {
        return objects(forKey: NSDeletedObjectsKey)
    }
    
    var refreshedObjects: Set<NSManagedObject> {
        return objects(forKey: NSRefreshedObjectsKey)
    }
    
    var invalidatedObjects: Set<NSManagedObject> {
        return objects(forKey: NSInvalidatedObjectsKey)
    }
    
    var invalidatedAllObjects: Bool {
        return notification.userInfo?[NSInvalidatedObjectsKey] != nil
    }
    
    var context: NSManagedObjectContext {
        guard let context = notification.object as? NSManagedObjectContext else {
            fatalError("Notification missing context")
        }
        
        return context
    }
    
    // MARK: - Private
    
    private func objects(forKey key: String) -> Set<NSManagedObject> {
        if let set = notification.userInfo?[key] as? Set<NSManagedObject> {
            return set
        } else {
            return []
        }
    }
    
}

extension NSManagedObjectContext {
    
    func createObjectsDidChangeNotificationObserver(handler
                                                    innerHandler: @escaping (ObjectsDidChangeNotification) -> Void)
        -> NSObjectProtocol {
        let center = NotificationCenter.default
        
        let outerHandler: ((Notification) -> Void) = { rawNotification in
            let notification = ObjectsDidChangeNotification(notification: rawNotification)
            innerHandler(notification)
        }
        
        let name = ObjectsDidChangeNotification.name
        
        let storedObserver = center.addObserver(forName: name, object: self,
                                                queue: nil, using: outerHandler)
        return storedObserver
    }
    
}
