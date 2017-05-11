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
    
    func addComponent(component: Component) {
        components.append(component)
    }
    
    func saveKit() {
        guard let realm = try? Realm() else {
            print("Failed to create realm")
            return
        }
        try? realm.write {
            for component in components {
                let object = component.createRealmObject()
                realm.add(object)
            }
            
        }
    }
}
