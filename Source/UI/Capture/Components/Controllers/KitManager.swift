//
//  KitManager.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import RealmSwift
import CoreData

class KitManager {
    static let currentKitRealm: Kit = {
        guard let realm = try? Realm() else {
            print("Failed to create realm")
            return Kit()
        }
        
        let kits: Results<KitRealm> = realm.objects(KitRealm.self)
        if kits.count == 0 {
            return Kit()
        }
        
        return kits[0].instance()
    }()
    
    static let currentKit: Kit = {
        let context = DataManager.context
        
        let fetchRequest = KitCoreData.sortedFetchRequest
        let results: [KitCoreData]
        do {
            results = try context.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch from Core Data store: \(error)")
            return Kit()
        }
        
        if results.count == 0 {
            return Kit()
        }
        
        let kit = results[0].instance()        
        return kit
    }()
}
