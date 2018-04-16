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
    enum StoreType {
        case sqlLite
        
        var coreValue: String {
            switch self {
            case .sqlLite:
                return NSSQLiteStoreType
            }
        }
    }
    
    static let context: NSManagedObjectContext = createGlobalContext()
    static let storeURL = store(name: "Slate")
    static let storeType = StoreType.sqlLite
    static let storeOptions: [AnyHashable: Any]? = nil
    
    // MARK: - Context Creation
    
    private static func createGlobalContext() -> NSManagedObjectContext {
        if Platform.isDebug {
            print("Loading database from \(storeURL.path)")
        }
        migrateIfNecessary()
        return createContext(storeURL: storeURL, storeType: storeType)
    }
    
    static func createContext(storeURL: URL?,
                              storeType: StoreType) -> NSManagedObjectContext {
        
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: DataModel.current.coreType)
        do {
            try storeCoordinator.addPersistentStore(ofType: storeType.coreValue,
                                                    configurationName: nil,
                                                    at: storeURL,
                                                    options: storeOptions)
        } catch let error {
            fatalError("Failed to open persistent store type: \(storeType) " +
                       "at \(String(describing: storeURL)): \(error)")
        }
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = storeCoordinator
        return context
    }
    
    private static func store(name: String) -> URL {
        let directory = URL.documentsDirectory
        return directory.appendingPathComponent("\(name).db")
    }
    
    // MARK: - Migration
    
    private static func migrateIfNecessary() {
        guard let storeVersion = self.storeVersion() else {
            return
        }
        
        if storeVersion != DataModel.currentVersion {
            print("Migration necessary from version \(storeVersion) to \(DataModel.currentVersion)")
            
            migrate(from: storeVersion)
        }
    }
    
    private static func storeVersion() -> DataModel.Version? {
        guard let metadata = DataModelMetadata(store: storeURL) else {
            return nil
        }
        
        return metadata.version
    }
    
    private static func migrate(from sourceVersion: DataModel.Version) {
        let migrator = DataMigrator(sourceVersion: sourceVersion)   
        migrator.migrate()
    }
    
}
