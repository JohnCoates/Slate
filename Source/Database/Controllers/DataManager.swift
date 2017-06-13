//
//  DataManager.swift
//  Slate
//
//  Created by John Coates on 6/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    static let context: NSManagedObjectContext = createContext()
    static let storeURL = store(name: "Slate")
    
    // MARK: - Context Creation
    
    private static func createContext() -> NSManagedObjectContext {
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        do {
            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                    configurationName: nil,
                                                    at: storeURL,
                                                    options: nil)
        } catch let error {
            fatalError("Failed to open persistent store at \(storeURL.path): \(error)")
        }
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = storeCoordinator
        return context
    }
    
    private static var objectModel: NSManagedObjectModel {
        let model = NSManagedObjectModel()
        var entities: [NSEntityDescription]
        let coreDataEntity = ComponentCoreData.modelEntity
        entities = [ KitCoreData.modelEntity, coreDataEntity]
        entities += ComponentCoreData.modelEntity.subentities
        
        model.entities = entities
        return model
    }
    
    private static func store(name: String) -> URL {
        let directory = URL.documentsDirectory
        return directory.appendingPathComponent("\(name).db")
    }
    
}
