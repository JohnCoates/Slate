//
//  KitManager.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import RealmSwift

class KitManager {
    static let currentKit: Kit = {
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
}
