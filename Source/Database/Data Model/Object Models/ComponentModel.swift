//
//  ComponentModel.swift
//  Slate
//
//  Created by John Coates on 6/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData
import CoreGraphics

@objc(ComponentCoreData)
class ComponentCoreData: NSManagedObject, Managed, DBObject {
    
    @NSManaged var frame: DBRect
    
    enum CodingKeys: String {
        case frame
        case rounding
        case opacity
    }
    
    class var entityName: String { return String(describing: self) }
    
    class var componentNewInstance: Component { fatalError("Missing component type") }
    
    class func modelEntity(version: DataModel.Version, graph: DataModelGraph) -> DBEntity {
        let entity = KeyedDBEntity<ComponentCoreData>(subentityCompatible: self)
        entity.add(attribute: .frame, type: .transformable)
        
        if let rounding = self as? EditRounding.Type {
            entity.add(attribute: .rounding, type: .float,
                       defaultValue: rounding.defaultRounding)
        }
        
        if let opacity = self as? EditOpacity.Type {
            entity.add(attribute: .opacity, type: .float,
                       defaultValue: opacity.defaultOpacity)
        }
        
        if self == ComponentCoreData.self {
            entity.subentities = [
                graph.getEntity(for: CaptureComponentCoreData.self),
                graph.getEntity(for: CameraPositionComponentCoreData.self)
            ]
        }
        return entity
    }
    
    class func entityPolicy(from: DataModel.Version,
                            to: DataModel.Version) -> NSEntityMigrationPolicy.Type? {
        if self == ComponentCoreData.self {
            
        }
        
        return nil
    }
    
    func instance() -> Component {
        let classType = type(of: self)
        let instance = classType.componentNewInstance
        
        instance.coreDataID = objectID
        configureWithStandardProperties(instance: instance)
        return instance
    }
    
    func configureWithStandardProperties(instance: Component) {
        if let dbObject = self as? EditRounding,
           let component = instance as? EditRounding {
           component.rounding = dbObject.rounding
        }
        
        if let dbObject = self as? EditOpacity,
            let component = instance as? EditOpacity {
            component.opacity = dbObject.opacity
        }
        
        instance.frame = frame.rect
    }
    
}
