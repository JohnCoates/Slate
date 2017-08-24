//
//  TestKitsPersistence.swift
//  Slate
//
//  Created by John Coates on 8/23/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import XCTest
#if os(iOS)
    @testable import Slate
#else
    @testable import macSlate
#endif
import CoreData

class TestKitsPersistence: XCTestCase {
    
    override func setUp() {
        super.setUp()
    
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    lazy var storeURL: URL = self.store(name: "testSaving")
    
    func testSaving() {
        deleteExistingStoreIfNecessary()
        let context = DataManager.createContext(storeURL: storeURL,
                                                storeType: .sqlLite)
        
        let kit = Kit()
        kit.name = "Test Save Kit"
        let expectation = self.expectation(description: "Save")
        kit.saveCoreData(withContext: context) { success in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error, "No error")
        }
    }
    
    func testSavingPart2_Loading() {
        let context = DataManager.createContext(storeURL: storeURL,
                                                storeType: .sqlLite)
        
        let fetchRequest = KitCoreData.sortedFetchRequest
        let results: [KitCoreData]
        do {
            results = try context.fetch(fetchRequest)
            XCTAssert(results.count == 1,
                      "Wrong Kit count in saved Kits, expected 1, found: \(results.count)")
        } catch let error {
            XCTFail("Failed to retrieve saved kit: \(error)")
        }
    }
    
    private func deleteExistingStoreIfNecessary() {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: storeURL.path) {
            try? fileManager.removeItem(at: storeURL)
        }
    }
    
    private func store(name: String) -> URL {
        let directory = URL.temporaryDirectory
        return directory.appendingPathComponent("\(name).db")
    }
    
}
