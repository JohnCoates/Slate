//
//  XCTestCase+TestableFatalError
//  Created on 4/15/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation
import XCTest
@testable import Slate

extension XCTestCase {
    
    func expectFatalError(execute: @escaping () -> Void) {
        let expectation = self.expectation(description: "Expect fatal error")
        
        TestableFatalError.beforeNever { _ in
            expectation.fulfill()
        }
        
        DispatchQueue.global(qos: .userInitiated).async(execute: execute)
        waitForExpectations(timeout: 0.1) { _ in
            TestableFatalError.restore()
        }
    }
}
