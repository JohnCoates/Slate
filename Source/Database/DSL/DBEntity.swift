//
//  DBEntity.swift
//  Slate
//
//  Created by John Coates on 6/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

class DBEntity {
    
    let coreType = NSEntityDescription()
    
    init(name: String, class objectClass: NSManagedObject.Type) {
        coreType.name = name
        coreType.managedObjectClassName = String(describing: objectClass)
    }
    
    @discardableResult
    func addAttribute(name: String,
                      type: DBAttributeType,
                      defaultValue: Any? = nil) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = type.coreType
        attribute.isIndexed = false
        attribute.isOptional = false
        attribute.defaultValue = defaultValue
        
        coreType.properties.append(attribute)
        return attribute
    }
    
    @discardableResult
    func addRelationship(name: String, entity: NSEntityDescription,
                         count: CountableClosedRange<Int>) -> NSRelationshipDescription {
        let relationship = NSRelationshipDescription()
        relationship.name = name
        relationship.destinationEntity = entity
        relationship.deleteRule = .cascadeDeleteRule
        relationship.isIndexed = false
        relationship.isOptional = false
        relationship.minCount = count.lowerBound
        relationship.maxCount = count.upperBound
        
        coreType.properties.append(relationship)
        return relationship
    }
    
    @discardableResult
    func addSingleRelationship(name: String, entity: NSEntityDescription) -> NSRelationshipDescription {
        let relationship = NSRelationshipDescription()
        relationship.name = name
        relationship.destinationEntity = entity
        relationship.deleteRule = .cascadeDeleteRule
        relationship.isIndexed = false
        relationship.isOptional = true
        relationship.minCount = 0
        relationship.maxCount = 1
        
        coreType.properties.append(relationship)
        return relationship
    }
    
    var subentities: [NSEntityDescription] {
        get {
            return coreType.subentities
        }
        set {
            coreType.subentities = newValue
        }
    }
}
