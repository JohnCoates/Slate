//
//  DataModelValidator.swift
//  Slate
//
//  Created by John Coates on 8/25/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

class DataModelValidator {
    
    func validate(entities: [NSEntityDescription], graph: DataModelGraph) -> Bool {
        var entityNames = graph.entityNames
        
        for entity in entities {
            guard let name = entity.name else {
                fatalError("Name missing for entity: \(entity)")
            }
            
            guard let index = entityNames.firstIndex(of: name) else {
                print("Entity \(name) is in entities list but not in the data model grah!")
                return false
            }
            
            entityNames.remove(at: index)
        }
        
        if entityNames.count > 0 {
            print("Entities: \(entityNames) are missing from the entity list but found in the data model graph!")
            return false
        }
        
        return true
    }
    
}
