//
//  TestPhotoSettingsVC
//  Created on 4/16/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import XCTest
@testable import Slate

class TestPhotoSettingsVC: XCTestCase {
    
    var vc: KitPhotoSettingsViewController!
    var kit: Kit!
    
    override func setUp() {
        super.setUp()
        
        let camera = TestCamera(position: .back)
        camera.highestFrameRateForResolutionClosure = { resolution in
            return 60
        }
        
        CurrentDevice.cameras = [camera]
        
        kit = Kit()
        vc = KitPhotoSettingsViewController(kit: kit)
        vc.loadViewForTesting()
    }
    
    override func tearDown() {
        super.tearDown()
        CurrentDevice.cameras = []
    }
    
    func test_has_four_sections() {
        XCTAssertEqual(vc.numberOfSections(in: vc.tableView), 4)
    }
}
