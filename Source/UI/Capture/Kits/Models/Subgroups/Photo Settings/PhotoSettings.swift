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
    var priorities: PhotoSettingsPriorities = PhotoSettingsPriorities()
    
    var resolutionConstrained: PhotoSettingsPriority? {
        if case .notSet = resolution {
            return nil
        }
        
        for camera in CurrentDevice.cameras {
            if let constrainedBy = resolutionConstrained(forCamera: camera) {
                return constrainedBy
            }
        }
        
        return nil
    }
    
    private func resolutionConstrained(forCamera camera: Camera) -> PhotoSettingsPriority? {
        let targetResolution = resolution.targetting(camera: camera)
        
        if priorities.is(priority: .frameRate, higherThan: .resolution) {
            let targetFrameRate = frameRate.targetting(camera: camera)
            if let bestResolution = camera.highestResolution(forTargetFrameRate: targetFrameRate) {
                if bestResolution.width < targetResolution.width || bestResolution.height < targetResolution.height {
                    return .frameRate
                }
            }
            
        }
        
        return nil
    }
    
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
        object.priorities = DBPhotoSettingsPriorities(priorities: priorities)
        
        return object
    }
    
}

// MARK: - Core Data

@objc(PhotoSettingsCoreData)
class PhotoSettingsCoreData: NSManagedObject, Managed, DBObject {
    
    enum CodingKeys: String {
        case resolution
        case frameRate
        case priorities
    }
    
    @NSManaged var resolution: DBPhotoResolution
    @NSManaged var frameRate: DBFrameRate
    @NSManaged var priorities: DBPhotoSettingsPriorities
    
    class var entityName: String { return String(describing: self) }
    
    class func modelEntity(version: DataModel.Version, graph: DataModelGraph) -> DBEntity {
        let entity = KeyedDBEntity<PhotoSettingsCoreData>()
        entity.add(attribute: .resolution, type: .transformable)
        
        if version >= .two {
            entity.add(attribute: .frameRate, type: .transformable)
        }
        if version >= .three {
            entity.add(attribute: .priorities, type: .transformable)
        }

        return entity
    }
    
    class func entityPolicy(from: DataModel.Version,
                            to: DataModel.Version) -> NSEntityMigrationPolicy.Type? {
        if from == .one, to == .two {
            return PhotoSettingsAddFrameRate.self
        } else if from == .two, to == .three {
            return PhotoSettingsAddPriorities.self
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
        instance.priorities = priorities.value
    }
    
}
