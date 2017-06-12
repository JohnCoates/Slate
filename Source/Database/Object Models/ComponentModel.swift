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
    
    @NSManaged public var frame: DBRect
    
    class var entityName: String { return String(describing: self) }
    class var modelEntity: NSEntityDescription { return constructModelEntity() }
    
    class var componentType: AnyClass { fatalError("Missing component type") }
    
    class func constructModelEntity() -> DBEntity {
        let entity = DBEntity(name: entityName,
                              class: self)
        
        entity.addAttribute(name: "frame", type: .transformable)
        
        return entity
    }
    
    func instance() -> Component {
        let classType = type(of: self)
        let untypedInstance = classType.init()
        guard let instance = untypedInstance as? Component else {
            fatalError("Class \(classType) doesn't conform to Component protocol")
        }
        
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
