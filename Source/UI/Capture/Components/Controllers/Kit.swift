//
//  Kit.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import RealmSwift

class Kit {
    var name: String = "Default Kit"
    var components = [Component]()
    var realmKey: Int?
    
    func addComponent(component: Component) {
        components.append(component)
    }
    
    func saveKit() {
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

class KitRealm: Object {
    dynamic var key = 0
    dynamic var name = "?"
    let components = List<ComponentUnionRealm>()
    
    func instance() -> Kit {
        let kit = Kit()
        kit.name = name
        kit.components = components.map({$0.instance()})
        return kit
    }
    
    override static func primaryKey() -> String? {
        return "key"
    }
}
