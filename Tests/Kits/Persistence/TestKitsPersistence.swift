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

class TestKitsPersistence: TestPersistence {
    
    override func setUp() {
        super.setUp()
        storeName = "testSaving"
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private let kitName = "Test Save Kit"
    
    func testSaving() {
        deleteExistingStoreIfNecessary()
        let context = DataManager.createContext(storeURL: storeURL,
                                                storeType: .sqlLite)
        
        let kit = Kit()
        kit.name = kitName
        let expectation = self.expectation(description: "Save")
        kit.saveCoreData(withContext: context) { success in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error, "No error")
        }
    }
    
    func testSaving2Load() {
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
            return
        }
        
        guard let kit = results.first else {
            XCTFail("Couldn't get first kit")
            return
        }
        
        XCTAssertEqual(kit.name, kitName, "Correct name")
    }
    
}
