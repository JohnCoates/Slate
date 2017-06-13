//
//  DBEntity.swift
//  Slate
//
//  Created by John Coates on 6/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

class DBEntity: NSEntityDescription {
    
    init(name: String, class objectClass: NSManagedObject.Type) {
        super.init()
        self.name = name
        self.managedObjectClassName = String(describing: objectClass)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        
        properties.append(attribute)
        return attribute
    }
    
    @discardableResult
    func addRelationship(name: String, entity: NSEntityDescription,
                         cardinality: CountableClosedRange<Int>) -> NSRelationshipDescription {
        let relationship = NSRelationshipDescription()
        relationship.name = name
        relationship.destinationEntity = entity
        relationship.deleteRule = .cascadeDeleteRule
        relationship.isIndexed = false
        relationship.isOptional = false
        relationship.minCount = 0
        relationship.maxCount = 10
        
        properties.append(relationship)
        return relationship
    }
    
}
