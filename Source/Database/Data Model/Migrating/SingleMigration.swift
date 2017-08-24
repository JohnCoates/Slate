//
//  SingleMigration.swift
//  Slate
//
//  Created by John Coates on 6/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

class SingleMigration {
    
    let from: DataModel.Version
    let to: DataModel.Version
    
    lazy var fromModel: DataModel = DataModel(version: self.from)
    lazy var toModel: DataModel = DataModel(version: self.to)
    
    init(from: DataModel.Version, to: DataModel.Version) {
        self.from = from
        self.to = to
    }
    
    func migrate() {
        let from = fromModel.coreType
        let to = toModel.coreType
        
        let manager = NSMigrationManager(sourceModel: from,
                                         destinationModel: to)
        
        removeStoreIfExists(at: temporaryStore)
        
        let store = DataManager.storeURL
        let type = DataManager.storeType
        let options = DataManager.storeOptions
        
        do {
            try manager.migrateStore(from: store,
                                     sourceType: type.coreValue,
                                     options: options,
                                     with: mappingModel,
                                     toDestinationURL: temporaryStore,
                                     destinationType: type.coreValue,
                                     destinationOptions: options)
        } catch let error {
            fatalError("Migration failed: \(error)")
        }
        
        moveStore(at: temporaryStore, to: store)
    }
    
    lazy var mappingModel: NSMappingModel = {
        let from = self.fromModel.coreType
        let to = self.toModel.coreType
        do {
            let model = try NSMappingModel.inferredMappingModel(forSourceModel: from,
                                                                destinationModel: to)
            self.hydrate(mappingModel: model)
//            print("mappings: \(model.entityMappings)")
            return model
        } catch let error {
            fatalError("Couldn't infer mapping model: \(error)")
        }
    }()
    
    var retainedExpressions = [NSExpression]()
    
    func hydrate(mappingModel: NSMappingModel) {
        guard let mappings = mappingModel.entityMappings else {
            fatalError("Missing entity mappings")
        }
        
        let graph = toModel.graph
        
        mappingModel.entityMappings = mappings.map { mapping in
            guard let entityName = mapping.sourceEntityName else {
                return mapping
            }
            
            let objectType = graph.managedObject(withEntityName: entityName)
            
            guard let policyClass = objectType.entityPolicy(from: from, to: to) else {
                return mapping
            }
            
            let className = String(describing: policyClass)
            
            let newMapping = NSEntityMapping()
            newMapping.mappingType = .customEntityMappingType
            newMapping.name = "\(entityName)Map"
            newMapping.entityMigrationPolicyClassName = className
            
            newMapping.sourceEntityName = mapping.sourceEntityName
            newMapping.sourceEntityVersionHash = mapping.sourceEntityVersionHash
            newMapping.destinationEntityName = mapping.destinationEntityName
            newMapping.destinationEntityVersionHash = mapping.destinationEntityVersionHash
            newMapping.sourceExpression = mapping.sourceExpression
            newMapping.attributeMappings = mapping.attributeMappings
            newMapping.relationshipMappings = mapping.relationshipMappings
            newMapping.userInfo = [
                "graph": graph,
                "from": from,
                "to": to
            ]
            
            return newMapping
        }
    }
    
    lazy var temporaryStore: URL = {
        let mainStore = DataManager.storeURL
        let from: Int = self.from.rawValue
        let to: Int = self.to.rawValue
        return mainStore.appendingPathExtension("\(from)-\(to).migration")
    }()
    
    // MARK: - File Management
    
    private func removeStoreIfExists(at: URL) {
        removeFileIfExists(at: at)
        let associatedFiles = associatedStoreFiles(forStore: at)
        for associatedFile in associatedFiles {
            removeFileIfExists(at: associatedFile)
        }
    }
    
    private func removeFileIfExists(at: URL) {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: at.path) else {
            return
        }
        do {
            try fileManager.removeItem(at: at)
        } catch let error {
            print("Couldn't remove file at \(at.path): \(error)")
        }
    }
    
    private func moveStore(at: URL, to: URL) {
        moveFileIfExists(at: at, to: to)
        
        let associatedSourceFiles = associatedStoreFiles(forStore: at)
        let associatedDestinationFiles = associatedStoreFiles(forStore: to)
        
        for (index, associatedFileAt) in associatedSourceFiles.enumerated() {
            let associatedFileTo = associatedDestinationFiles[index]
            moveFileIfExists(at: associatedFileAt, to: associatedFileTo)
        }
    }
    
    private func moveFileIfExists(at: URL, to: URL) {
        removeFileIfExists(at: to)
        
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: at.path) else {
            return
        }
        
        do {
            try fileManager.moveItem(at: at, to: to)
        } catch let error {
            print("Couldn't move store from \(at.path) to \(to.path): \(error)")
        }
    }
    
    private func associatedStoreFiles(forStore store: URL) -> [URL] {
        let writeAheadLog = store.appendingPathPostfix("-wal")
        let sharedMemoryFile = store.appendingPathPostfix("-shm")
        
        return [writeAheadLog, sharedMemoryFile]
    }

}
