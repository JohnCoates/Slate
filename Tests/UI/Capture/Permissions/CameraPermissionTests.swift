//
//  CameraPermissionTests
//  Created on 4/13/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import XCTest
@testable import Slate

class CameraPermissionsTest: XCTestCase {
    func testButtonTap() {
        let vc = CameraDeniedPermisionViewController()
        vc.loadViewForTesting()
    }
}
