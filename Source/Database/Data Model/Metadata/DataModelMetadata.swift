//
//  DataModelMetadata.swift
//  Slate
//
//  Created by John Coates on 6/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

private typealias LocalClass = DataModelMetadata

class DataModelMetadata {
    let metadata: [String: Any]
    
    init?(store: URL) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: store.path) {
            return nil
        }
        
        self.metadata = DataModelMetadata.metadata(from: store)
    }
    
    var version: DataModel.Version {
        guard let versionIdentifiers = metadata[NSStoreModelVersionIdentifiersKey] as? [String] else {
            fatalError("Metadata is missing version identifiers")
        }
        
        for identifier in versionIdentifiers where identifier.hasPrefix(DataModel.versionPrefix) {
            return version(fromIdentifier: identifier)
        }
        
        fatalError("Metadata is missing data model version")
    }
    
    private func version(fromIdentifier identifier: String) -> DataModel.Version {
        let prefixLength: Int = DataModel.versionPrefix.count
        let startIndex = identifier.index(identifier.startIndex,
                                          offsetBy: prefixLength)
        let rawVersionString = identifier.substring(from: startIndex)
        guard let rawVersion = Int(rawVersionString) else {
            fatalError("Couldn't convert version \(rawVersionString) to Int")
        }
        
        guard let version = DataModel.Version(rawValue: rawVersion) else {
            fatalError("Invalid version: \(rawVersion)")
        }
        
        return version
    }
    
    // MARK: - Initialization Helpers
    
    static func metadata(from store: URL) -> [String: Any] {
        do {
            let type = DataManager.storeType.coreValue
            let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: type,
                                                                                       at: store,
                                                                                       options: nil)
            return metadata
        } catch let error {
            fatalError("Error getting metadata for \(store.path): \(error)")
        }
    }
    
}
