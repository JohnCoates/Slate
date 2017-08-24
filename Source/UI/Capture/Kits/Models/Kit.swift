//
//  Kit.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import CoreData

class Kit {
    
    var name: String = "Default Kit"
    var components = [Component]()
    var coreDataID: NSManagedObjectID?
    lazy var nativeSize: Size = {
       return Size(UIScreen.main.bounds.size)
    }()
    
    weak var dbObject: KitCoreData?
    
    func addComponent(component: Component) {
        components.append(component)
    }
    
    func saveKit() {
        DispatchQueue.main.async {
            self.saveCoreData(withContext: DataManager.context)
        }
    }
    
}

// MARK: - Core Data

extension Kit {
    
    func databaseObject(in context: NSManagedObjectContext) -> KitCoreData {
        let object: KitCoreData
        
        if let dbObject = dbObject {
            return dbObject
        } else if let coreDataID = coreDataID {
            object = context.object(fromID: coreDataID)
            self.dbObject = object
        } else {
            object = newDatabaseObject(in: context)
            self.dbObject = object
        }
        
        return object
    }
    
    func newDatabaseObject(in context: NSManagedObjectContext) -> KitCoreData {
        let object: KitCoreData = context.insertObject()
        return object
    }
    
    typealias SaveCompletion = (Bool) -> Void
    func saveCoreData(withContext context: NSManagedObjectContext,
                      completion: SaveCompletion? = nil) {
        var savedObject: KitCoreData?
        
        context.performChanges(block: {
            let object = self.databaseObject(in: context)
            self.coreDataID = object.objectID
            object.name = self.name
            savedObject = object
            
            object.components = Set(self.components.map { $0.databaseObject(withMutableContext: context) })
        }, afterChanges: { success in
            guard success, let savedObject = savedObject else {
                fatalError("Failed to save kit!")
                
            }
            
            self.propogateObjectIDs(fromSavedObject: savedObject)
            completion?(success)
        })
    }
    
    func saveComponent<T: GenericComponent>(in context: NSManagedObjectContext, component: T) {
//        let dbObject = component.newDatabaseObject(in: context)
        
    }
    
    func propogateObjectIDs(fromSavedObject savedObject: KitCoreData) {
        guard !savedObject.objectID.isTemporaryID else {
            fatalError("Saved object id is unexpectantly temporary")
        }
        
        self.coreDataID = savedObject.objectID
        
        for component in components {
            guard let dbObject = component.dbObject else {
                fatalError("Component is missing database object!")
            }
            
            guard !dbObject.objectID.isTemporaryID else {
                fatalError("Component object ID is unexpectantly temporary")
            }
            
            component.coreDataID = dbObject.objectID
        }
    }
    
}

@objc (KitCoreData)
class KitCoreData: NSManagedObject, Managed {
    @NSManaged var name: String
    @NSManaged var components: Set<ComponentCoreData>
    
    class var entityName: String { return String(describing: self) }
    
    class func modelEntity(version: DataModel.Version, graph: DataModelGraph) -> DBEntity {
        let entity = DBEntity(name: entityName,
                              class: self)
        
        let componentEntity = graph.getEntity(for: ComponentCoreData.self)
        entity.addAttribute(name: "name", type: .string)
        entity.addRelationship(name: "components",
                               entity: componentEntity,
                               cardinality: 0...0)
        
        return entity
    }
    
    func instance() -> Kit {
        let kit = Kit()
        kit.coreDataID = objectID
        kit.name = name
        kit.components = components.map { $0.instance() }
        return kit
    }
    
    override var description: String {
        return "[Kit \(name)]"
    }
}
