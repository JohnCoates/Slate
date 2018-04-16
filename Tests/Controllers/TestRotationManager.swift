//
//  TestRotationManager
//  Created on 4/15/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import XCTest
@testable import Slate

class TestRotationManager: XCTestCase {
    
    func test_running_false_by_default() {
        XCTAssertFalse(RotationManager.running)
        
    }
    
    func test_running_corresponds_to_begin_and_end_calls() {
        RotationManager.beginOrientationEvents()
        XCTAssertTrue(RotationManager.running)
        
        RotationManager.endOrientationEvents()
        XCTAssertFalse(RotationManager.running)
    }
    
    func test_unbalanced_end_causes_fatal_error() {
        expectFatalError {
            RotationManager.endOrientationEvents()
        }
    }
}
