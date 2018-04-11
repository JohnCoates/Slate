//
//  TestPhotoSettingsConstraints
//  Created on 4/11/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import XCTest
#if os(iOS)
    @testable import Slate
#else
    @testable import macSlate
#endif

class TestPhotoSettingsConstraints: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testConstrainedResolution() {
        let targetResolution = IntSize(width: 1920, height: 1080)
        let frameRateBestResolution = IntSize(width: 1280, height: 720)
        
        let targetFrameRate = 60
        let photoSettings = PhotoSettings()
        photoSettings.frameRate = .custom(rate: targetFrameRate)
        photoSettings.resolution = .custom(width: targetResolution.width,
                                           height: targetResolution.height)
        
        photoSettings.priorities.items = [
            .frameRate,
            .resolution,
            .burstSpeed
        ]
        
        let camera = TestCamera(position: .back)
        camera.highestResolutionForFrameRateClosure = { frameRate in
            if frameRate == targetFrameRate {
                return frameRateBestResolution
            } else {
                return targetResolution
            }
        }
        CurrentDevice.cameras = [camera]
        
        guard let resolutionConstraints = photoSettings.constraintsResolver.constraints(for: photoSettings.resolution) else {
            XCTFail("Resolution must be constrained")
            return
        }
        
        XCTAssertEqual(resolutionConstraints.count, 1, "Correct amount of constraints")
        let resolvedResolution = photoSettings.constraintsResolver.value(for: photoSettings.resolution,
                                                                         camera: camera,
                                                                         afterConstraints: resolutionConstraints)
        
        XCTAssertEqual(resolvedResolution, frameRateBestResolution, "Solved constrained resolution value correctly.")
    }
    
}
