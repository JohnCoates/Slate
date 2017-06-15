//
//  DataMigrator.swift
//  Slate
//
//  Created by John Coates on 6/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

class DataMigrator {
    
    let sourceVersion: DataModel.Version
    
    init(sourceVersion: DataModel.Version) {
        self.sourceVersion = sourceVersion
    }
    
    func migrate() {
        var oldVersion = sourceVersion
        let currentVersion = DataModel.currentVersion
        
        while let newVersion = oldVersion.nextVersion() {
            if !Platform.isProduction {
                print("Migrating from \(oldVersion) to \(newVersion)")
            }
            migrate(from: oldVersion, to: newVersion)
            
            if newVersion == currentVersion {
                break
            }
            
            oldVersion = newVersion
        }
    }
    
    private func migrate(from: DataModel.Version, to: DataModel.Version) {
        let migrator = SingleMigration(from: from, to: to)
        migrator.migrate()
    }
    
}
