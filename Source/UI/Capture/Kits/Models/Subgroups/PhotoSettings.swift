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
    enum Resolution: CustomDebugStringConvertible {
        case custom(width: CGFloat, height: CGFloat)
        case maximum
        case notSet
        
        var kind: Int {
            switch self {
            case .custom:
                return 0
            case .maximum:
                return 1
            case .notSet:
                return 2
            }
        }
        
        init(kind: Int, size: CGSize?) {
            switch kind {
            case 0:
                guard let size = size else {
                    fatalError("Custom resolution missing size!")
                }
                self = .custom(width: size.width, height: size.height)
            case 1:
                self = .maximum
            case 2:
                self = .notSet
            default:
                fatalError("Unsupported kind for resolution: \(kind)")
            }
        }
        
        var debugDescription: String {
            var value: String
            switch self {
            case let .custom(width, height):
                value = "custom: \(width)x\(height)"
            case .maximum:
                value = "maximum"
            case .notSet:
                value = "notSet"
            }
            return "[PhotoSettings \(value)]"
        }
    }
    
    enum FrameRate {
        case custom(rate: Float)
        case maximum
        case notSet
    }
    
    enum BurstSpeed {
        case custom(speed: Int)
        case maximum
        case notSet
    }
    
    var resolution: Resolution = .notSet
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
        
        return object
    }
}

@objc(PhotoSettingsCoreData)
class PhotoSettingsCoreData: NSManagedObject, Managed {
    
    @NSManaged var resolution: DBPhotoResolution
    
    class var entityName: String { return String(describing: self) }
    
    class func modelEntity(version: DataModel.Version, graph: DataModelGraph) -> DBEntity {
        let entity = DBEntity(name: entityName,
                              class: self)
//        print("entity: \(entityName)")
        entity.addAttribute(name: "resolution", type: .transformable)

        return entity
    }
    
    class func entityPolicy(from: DataModel.Version,
                            to: DataModel.Version) -> NSEntityMigrationPolicy.Type? {
        
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
    }
}
