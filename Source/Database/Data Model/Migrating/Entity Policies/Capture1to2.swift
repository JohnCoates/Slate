//
//  CaptureToCapture1to2.swift
//  Slate
//
//  Created by John Coates on 6/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

@objc(Capture1to2)
class Capture1to2: EntityMigrationPolicy {
    
    override func createDestinationInstances(forSource source: NSManagedObject,
                                             in mapping: NSEntityMapping,
                                             manager: NSMigrationManager) throws {
        guard let entityName = source.entity.name else {
            fatalError("Missing entity name for instance")
        }
        
        let destination = NSEntityDescription.insertNewObject(forEntityName: entityName,
                                                              into: manager.destinationContext)
        
        guard let attributeMappings = mapping.attributeMappings else {
            fatalError("Missing attribute mappings")
        }
        migrate(source: source, destination: destination, attributeMappings: attributeMappings)
        destination.setValue(Float(1), forKey: "versionTwo")
        
        manager.associate(sourceInstance: source,
                          withDestinationInstance: destination,
                          for: mapping)
    }
    
}
