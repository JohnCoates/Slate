//
//  DataModelGraph.swift
//  Slate
//
//  Created by John Coates on 6/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

class DataModelGraph {
    private var entities = [NSEntityDescription]()
    private var managedObjects = [Managed.Type]()
    
    let version: DataModel.Version
    init(version: DataModel.Version) {
        self.version = version
    }
    
    func getEntity<ObjectType: Managed>(for type: ObjectType.Type) -> NSEntityDescription {
        let name = ObjectType.entityName
        
        for entity in entities where entity.name == name {
            return entity
        }
        
        let entity = ObjectType.modelEntity(version: version, graph: self)
        entities.append(entity.coreType)
        managedObjects.append(type)
        return entity.coreType
    }
    
    func managedObject(withEntityName entityName: String) -> Managed.Type {
        for object in managedObjects where object.entityName == entityName {
            return object
        }
        
        fatalError("Graph is missing managed object with entity name: \(entityName)")
    }
    
}
