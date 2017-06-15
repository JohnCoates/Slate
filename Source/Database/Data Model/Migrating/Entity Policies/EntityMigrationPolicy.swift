//
//  EntityMigrationPolicy.swift
//  Slate
//
//  Created by John Coates on 6/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

class EntityMigrationPolicy: NSEntityMigrationPolicy {
    
    func migrate(source: NSManagedObject, destination: NSManagedObject,
                 attributeMappings: [NSPropertyMapping]) {
        
        for attribute in attributeMappings {
            guard let name = attribute.name,
                let valueExpression = attribute.valueExpression else {
                    continue
            }
            let context: NSMutableDictionary = ["source": source]
            
            let value: Any = valueExpression.expressionValue(with: source,
                                                             context: context) as Any
            print("mapping key \(name) to value \(value)")
            destination.setValue(value, forKey: name)
        }
    }
    
    func migrateValue(named key: String, from: NSManagedObject, to: NSManagedObject) {
        let value = from.value(forKey: key)
        to.setValue(value, forKey: key)
    }
    
}
