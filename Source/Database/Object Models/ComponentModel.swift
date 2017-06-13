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
class ComponentCoreData: NSManagedObject, Managed {
    
    @NSManaged var frame: DBRect
    
    class var entityName: String { return String(describing: self) }
    class var modelEntity: NSEntityDescription { return constructModelEntity() }
    
    class var componentNewInstance: Component { fatalError("Missing component type") }
    
    // This model entity is used so the same one is used
    // when this object is referenced by a relationship property
    private static weak var ephemeralEntity: DBEntity?
    
    class func constructModelEntity() -> DBEntity {
        if self == ComponentCoreData.self, let ephemeralEntity = ephemeralEntity {
            return ephemeralEntity
        }
        
        let entity = DBEntity(name: entityName,
                              class: self)
        
        entity.addAttribute(name: "frame", type: .transformable)
        
        if self == ComponentCoreData.self {
            entity.subentities = [
                CaptureComponentCoreData.modelEntity,
                CameraPositionComponentCoreData.modelEntity
            ]
        }
        
        if self == ComponentCoreData.self {
            ephemeralEntity = entity
        }
        return entity
    }
    
    func instance() -> Component {
        let classType = type(of: self)
        let instance = classType.componentNewInstance
        
        guard let instanceDatabase = instance as? ComponentDatabase else {
            fatalError("Can't init an object that doesn't conform to ComponentDatabase")
        }
        instanceDatabase.coreDataID = objectID
        
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
