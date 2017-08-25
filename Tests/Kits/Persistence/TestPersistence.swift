//
//  TestPersistence.swift
//  Slate
//
//  Created by John Coates on 8/24/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import XCTest
#if os(iOS)
    @testable import Slate
#else
    @testable import macSlate
#endif
import CoreData

class TestPersistence: XCTestCase {
    
    var storeName = "testPersistence"
    
    lazy var storeURL: URL = self.store(name: self.storeName)
    
    func deleteExistingStoreIfNecessary() {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: storeURL.path) {
            try? fileManager.removeItem(at: storeURL)
        }
    }
    
    func store(name: String) -> URL {
        let directory = URL.temporaryDirectory
        return directory.appendingPathComponent("\(name).db")
    }
    
}
