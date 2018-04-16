//
//  CameraDeniedPermissionTests
//  Created on 4/13/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import XCTest
@testable import Slate

class CameraDeniedPermissionTests: XCTestCase {
    func open_settings_opens_settings() {
        let vc = CameraDeniedPermisionViewController()
        vc.loadViewForTesting()
        
        let mockApplication = MockUIApplication()
        vc.application = mockApplication
        vc.openSettings()
        
        let openedURL = mockApplication.urlOpened!
        XCTAssertEqual(openedURL.absoluteString, UIApplicationOpenSettingsURLString)
    }
}

class MockUIApplication: UIApplication {
    var urlOpened: URL?
    
    override func openURL(_ url: URL) -> Bool {
        urlOpened = url
        return true
    }
}
