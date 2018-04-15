//
//  TestRotationManager
//  Created on 4/15/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import XCTest
@testable import Slate

class TestRotationManager: XCTestCase {
    
    func testBeginEnd() {
        XCTAssertFalse(RotationManager.running)
        
        RotationManager.beginOrientationEvents()
        XCTAssertTrue(RotationManager.running)
        
        RotationManager.endOrientationEvents()
        XCTAssertFalse(RotationManager.running)
        
        expectFatalError {
            RotationManager.endOrientationEvents()
        }
    }
}
