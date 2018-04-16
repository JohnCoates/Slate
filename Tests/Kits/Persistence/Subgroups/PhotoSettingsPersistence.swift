//
//  PhotoSettingsPersistence.swift
//  Slate
//
//  Created by John Coates on 8/24/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable force_try

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
        kit.photoSettings.priorities.items = [
            .burstSpeed,
            .resolution,
            .frameRate
        ]
        
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
        results = try! context.fetch(fetchRequest)
        XCTAssert(results.count == 1,
                  "Wrong Kit count in saved Kits, expected 1, found: \(results.count)")
        
        let coreDataKit = results.first!
        
        let kit = coreDataKit.instance()
        let photoSettings = kit.photoSettings
        let resolution = photoSettings.resolution
        let priorities = photoSettings.priorities
        
        if case let .custom(width, height) = resolution {
            XCTAssertEqual(width, 1280, "Correct photo resolution width")
            XCTAssertEqual(height, 720, "Correct photo resolution height")
            XCTAssertEqual(priorities.items[0], .burstSpeed,
                           "Correct priority order")
            XCTAssertEqual(priorities.items[1], .resolution,
                           "Correct priority order")
            XCTAssertEqual(priorities.items[2], .frameRate,
                           "Correct priority order")
        } else {
            XCTFail("Missing photo resolution!")
        }
    }
    
}
