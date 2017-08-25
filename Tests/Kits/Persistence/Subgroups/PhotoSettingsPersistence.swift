//
//  PhotoSettingsPersistence.swift
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

class PhotoSettingsPersistence: TestPersistence {
    
    override func setUp() {
        super.setUp()
        storeName = "testSaving"
    }
    
    func testSaving() {
        deleteExistingStoreIfNecessary()
        let context = DataManager.createContext(storeURL: storeURL,
                                                storeType: .sqlLite)
        
        let kit = Kit()
        kit.name = "Photo Settings Kit"
        
        kit.photoSettings.resolution = .custom(width: 1280, height: 720)
        
        let expectation = self.expectation(description: "Save")
        kit.saveCoreData(withContext: context) { success in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error, "No error")
        }
    }
    
    func testSaving2_Load() {
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
        
        guard let coreDataKit = results.first else {
            XCTFail("Couldn't get first kit")
            return
        }
        
        let kit = coreDataKit.instance()
        let photoSettings = kit.photoSettings
        let resolution = photoSettings.resolution
        
        if case let .custom(width, height) = resolution {
            XCTAssertEqual(width, 1280, "Correct photo resolution width")
            XCTAssertEqual(height, 720, "Correct photo resolution height")
        } else {
            XCTFail("Missing photo resolution!")
        }
    }
}
