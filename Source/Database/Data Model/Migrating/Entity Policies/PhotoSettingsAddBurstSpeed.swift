//
//  PhotoSettingsAddBurstSpeed
//  Created on 4/11/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import CoreData

@objc(PhotoSettingsAddBurstSpeed)
class PhotoSettingsAddBurstSpeed: EntityMigrationPolicy {
    
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
        
        destination.set(object: PhotoSettingsCoreData.self,
                        value: DBBurstSpeed(burstSpeed: .notSet),
                        forKey: .burstSpeed)
        
        manager.associate(sourceInstance: source,
                          withDestinationInstance: destination,
                          for: mapping)
    }
    
}
