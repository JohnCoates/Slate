//
//  Kit.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import RealmSwift
import CoreData

class Kit {
    var name: String = "Default Kit"
    var components = [Component]()
    var realmKey: Int?
    var coreDataID: NSManagedObjectID?
    
    func addComponent(component: Component) {
        components.append(component)
    }
    
    func saveKit() {
        DispatchQueue.main.async {
            self.saveCoreData(withContext: DataManager.context)
        }
    }
    
}

// MARK: - Realm

class KitRealm: Object {
    dynamic var key = 0
    dynamic var name = "?"
    let components = List<ComponentUnionRealm>()
    
    func instance() -> Kit {
        let kit = Kit()
        kit.name = name
        kit.components = components.map {$0.instance()}
        return kit
    }
    
    override static func primaryKey() -> String? {
        return "key"
    }
    
}

extension Kit {
    
    func saveKitRealm() {
        let realm: Realm
        do {
            realm = try Realm()
        } catch let error as NSError {
            print("Failed to create realm: \(error)")
            return
        }
        
        try? realm.write {
            let key: Int
            if let realmKey = realmKey {
                key = realmKey
            } else {
                key = nextKey(realm: realm)
            }
            let realmKit = KitRealm()
            realmKit.key = key
            realmKit.name = name
            
            for component in components {
                let unionObject = ComponentUnionRealm()
                unionObject.configure(withComponent: component)
                realmKit.components.append(unionObject)
            }
            
            realm.add(realmKit, update: true)
        }
    }
    
    func nextKey(realm: Realm) -> Int {
        let allKits = realm.objects(KitRealm.self)
        let maxOptional = allKits.max(ofProperty: KitRealm.primaryKey()!) as Int?
        if let max = maxOptional {
            return max
        } else {
            return 0
        }
    }
    
}

// MARK: - Core Data

extension Kit {
    
    func databaseObject(in context: NSManagedObjectContext) -> KitCoreData {
        let object: KitCoreData
        if let coreDataID = coreDataID {
            object = context.object(fromID: coreDataID)
        } else {
            object = newDatabaseObject(in: context)
        }
        
        return object
    }
    
    func newDatabaseObject(in context: NSManagedObjectContext) -> KitCoreData {
        let object: KitCoreData = context.insertObject()
        return object
    }
    
    func saveCoreData(withContext context: NSManagedObjectContext) {
        
        context.performChanges {
            let object = self.databaseObject(in: context)
            object.name = self.name
            
            let components: [ComponentDatabase] = self.components.map {
                guard let dbComponent = $0 as? ComponentDatabase else {
                    fatalError("Component \($0) doesn't conform to ComponentDatabase")
                }
                return dbComponent
            }
            
            print("saving components: \(components)")
            
            object.components = Set(components.map { $0.databaseObject(in: context) })
        }
    }
    
}

@objc (KitCoreData)
class KitCoreData: NSManagedObject, Managed {
    @NSManaged var name: String
    @NSManaged var components: Set<ComponentCoreData>
    
    class var entityName: String { return String(describing: self) }
    class var modelEntity: NSEntityDescription { return constructModelEntity() }
    
    class func constructModelEntity() -> DBEntity {
        let entity = DBEntity(name: entityName,
                              class: self)
        
        entity.addAttribute(name: "name", type: .string)
        entity.addRelationship(name: "components",
                               entity: ComponentCoreData.modelEntity,
                               cardinality: 0...0)
        
        return entity
    }
    
    func instance() -> Kit {
        let kit = Kit()
        kit.coreDataID = objectID
        kit.name = name
        kit.components = components.map {$0.instance()}
        return kit
    }
    
    override var description: String {
        return "[Kit \(name)]"
    }
}
