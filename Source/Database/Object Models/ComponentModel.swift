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
    
    class func constructModelEntity() -> DBEntity {
        let entity = DBEntity(name: entityName,
                              class: self)
        
        entity.addAttribute(name: "frame", type: .transformable)
        
        return entity
    }
    
}
