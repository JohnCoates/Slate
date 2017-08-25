//
//  DataModel.swift
//  Slate
//
//  Created by John Coates on 6/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

class DataModel {
    
    enum Version: Int, Comparable {
        case one = 1
        
        func nextVersion() -> Version? {
            let nextInt = self.rawValue + 1
            if let next = Version.init(rawValue: nextInt) {
                return next
            } else {
                return nil
            }
        }
        
    }
    
    static let currentVersion: Version = .one
    
    // MARK: - Convenience 
    
    static var current: DataModel {
        return DataModel(version: currentVersion)
    }
    
    let coreType = NSManagedObjectModel()
    
    // MARK: - Entities
    
    let graph: DataModelGraph
    
    func setUpEntities() {
        var entities: [NSEntityDescription]
        let componentBase = graph.getEntity(for: ComponentCoreData.self)
        entities = [ graph.getEntity(for: KitCoreData.self),
                     graph.getEntity(for: PhotoSettingsCoreData.self),
                     componentBase]
        entities += componentBase.subentities
        
        coreType.entities = entities
    }
    
    // MARK: - Init
    
    let version: Version
    init(version: Version) {
        self.version = version
        graph = DataModelGraph(version: version)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class is not NSCoder compliant")
    }    
    
    func setup() {
        setUpEntities()
        setUpVersion()
    }
    
    // MARK: - Version
    
    static let versionPrefix = "Core."
    
    func setUpVersion() {
        let prefix = DataModel.versionPrefix
        let coreVersion = "\(prefix)\(version.rawValue)"
        coreType.versionIdentifiers = [ coreVersion ]
    }
    
}

// MARK: - Comparable Version

func < (a: DataModel.Version, b: DataModel.Version) -> Bool {
    return a.rawValue < b.rawValue
}
