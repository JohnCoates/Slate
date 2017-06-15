//
//  MangedObjectType.swift
//  Slate
//
//  Created by John Coates on 6/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

protocol Managed: class, NSFetchRequestResult {
    
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    
    static func modelEntity(version: DataModel.Version,
                            graph: DataModelGraph) -> DBEntity
    
    static func entityPolicy(from: DataModel.Version,
                             to: DataModel.Version) -> NSEntityMigrationPolicy.Type?
    
}

extension Managed {
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
    
    static func entityPolicy(from: DataModel.Version,
                             to: DataModel.Version) -> NSEntityMigrationPolicy.Type? {
        return nil
    }
    
}
