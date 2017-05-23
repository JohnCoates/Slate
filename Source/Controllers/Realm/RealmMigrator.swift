//
//  RealmMigrator.swift
//  Slate
//
//  Created by John Coates on 5/21/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import RealmSwift

class RealmMigrator {
    static let currentVersion: UInt64 = 3
    class func migrate() {
        let config = Realm.Configuration(schemaVersion: currentVersion,
                                         migrationBlock: { migration, oldVersion in
            perform(migration: migration, oldVersion: oldVersion)
        })
        
        Realm.Configuration.defaultConfiguration = config
        do {
            _ = try Realm()
        } catch let error as NSError {
            print("Error opening realm: \(error)")
        }
    }
    
    private class func perform(migration: RealmSwift.Migration, oldVersion: UInt64) {
        if oldVersion < 1 {
            migration.addProperty(toClass: CameraPositionComponentRealm.self,
                                  key: "rounding", defaultValue: CameraPositionComponent.defaultRounding)
        }
        if oldVersion < 2 {
            // added capture component
        }
        if oldVersion < 3 {
            migration.addProperty(toClass: CaptureComponentRealm.self,
                                  key: "opacity", defaultValue: CaptureComponent.defaultOpacity)
        }
    }
    
    // MARK: - Utility functions
}

// MARK: - Utility Extension

extension RealmSwift.Migration {
    func addProperty<T>(toClass realmClass: RealmSwift.Object.Type,
                        key: String, defaultValue value: T) {
        enumerateObjects(ofType: realmClass.className()) { oldObject, newObject in
            newObject?[key] = value
        }
    }
}
