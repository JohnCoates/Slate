//
//  DBEntity.swift
//  Slate
//
//  Created by John Coates on 6/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

protocol DBEntity {
    var coreType: NSEntityDescription { get }
    var subentities: [NSEntityDescription] { get }
}

class KeyedDBEntity<Object>: DBEntity where Object: DBObject, Object: NSManagedObject {
    
    let coreType = NSEntityDescription()
    
    /// Use this if the model has subentities
    convenience init(subentityCompatible managed: NSManagedObject.Type) {
        let className = String(describing: managed)
        self.init(className: className)
    }
    
    convenience init() {
        let className = String(describing: Object.self)
        self.init(className: className)
    }
    
    private init(className: String) {
        coreType.name = className
        coreType.managedObjectClassName = className
    }
    
    @discardableResult
    func add(attribute: Object.CodingKeys,
             type: DBAttributeType,
             defaultValue: Any? = nil) -> NSAttributeDescription {
        let description = NSAttributeDescription()
        description.name = attribute.rawValue
        description.attributeType = type.coreType
        description.isIndexed = false
        description.isOptional = false
        description.defaultValue = defaultValue
        
        coreType.properties.append(description)
        return description
    }
    
    @discardableResult
    func add(relationship: Object.CodingKeys,
             entity: NSEntityDescription,
             count: CountableClosedRange<Int>) -> NSRelationshipDescription {
        let description = NSRelationshipDescription()
        description.name = relationship.rawValue
        description.destinationEntity = entity
        description.deleteRule = .cascadeDeleteRule
        description.isIndexed = false
        description.isOptional = false
        description.minCount = count.lowerBound
        description.maxCount = count.upperBound
        
        coreType.properties.append(description)
        return description
    }
    
    @discardableResult
    func add(singleRelationship relationship: Object.CodingKeys,
             entity: NSEntityDescription) -> NSRelationshipDescription {
        let description = NSRelationshipDescription()
        description.name = relationship.rawValue
        description.destinationEntity = entity
        description.deleteRule = .cascadeDeleteRule
        description.isIndexed = false
        description.isOptional = true
        description.minCount = 0
        description.maxCount = 1
        
        coreType.properties.append(description)
        return description
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

protocol DBObject {
    associatedtype CodingKeys: RawRepresentable where CodingKeys.RawValue == String
}
