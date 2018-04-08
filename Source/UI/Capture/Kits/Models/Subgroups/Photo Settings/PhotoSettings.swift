//
//  PhotoSettings.swift
//  Slate
//
//  Created by John Coates on 8/23/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreData

class PhotoSettings {
    
    enum BurstSpeed {
        case custom(speed: Int)
        case maximum
        case notSet
    }
    
    var resolution: PhotoResolution = .notSet
    var frameRate: FrameRate = .notSet
    var burstSpeed: BurstSpeed = .notSet
    
    var coreDataID: NSManagedObjectID?
    private var coreDataObject: PhotoSettingsCoreData?
    
    func databaseObject(withMutableContext context: NSManagedObjectContext) -> PhotoSettingsCoreData {
        let object: PhotoSettingsCoreData
        
        if let dbObject = coreDataObject {
            object = dbObject
        } else if let coreDataID = coreDataID {
            object = context.object(fromID: coreDataID)
        } else {
            object = context.insertObject()
        }
        coreDataObject = object
        object.resolution = DBPhotoResolution(resolution: resolution)
        object.frameRate = DBFrameRate(frameRate: frameRate)
        
        return object
    }
    
}

// MARK: - Core Data

@objc(PhotoSettingsCoreData)
class PhotoSettingsCoreData: NSManagedObject, Managed {
    
    @NSManaged var resolution: DBPhotoResolution
    @NSManaged var frameRate: DBFrameRate
    
    class var entityName: String { return String(describing: self) }
    
    class func modelEntity(version: DataModel.Version, graph: DataModelGraph) -> DBEntity {
        let entity = DBEntity(name: entityName,
                              class: self)
        entity.addAttribute(name: "resolution", type: .transformable)
        
        if version >= .two {
            entity.addAttribute(name: "frameRate", type: .transformable)
        }

        return entity
    }
    
    class func entityPolicy(from: DataModel.Version,
                            to: DataModel.Version) -> NSEntityMigrationPolicy.Type? {
        if from == .one, to == .two {
            return PhotoSettingsAddFrameRate.self
        }
        return nil
    }
    
    func instance() -> PhotoSettings {
        let instance = PhotoSettings()
        
        instance.coreDataID = objectID
        configureWithStandardProperties(instance: instance)
        return instance
    }
    
    func configureWithStandardProperties(instance: PhotoSettings) {
        instance.resolution = resolution.value
        instance.frameRate = frameRate.value
    }
    
}
