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
                return frameRateBestResolution
        }
        CurrentDevice.cameras = [camera]
        let resolver = photoSettings.constraintsResolver
        let resolutionConstraints = resolver.constraints(for: photoSettings.resolution)!
        
        XCTAssertEqual(resolutionConstraints.count, 1, "Correct amount of constraints")
        let resolvedResolution = photoSettings.constraintsResolver.value(for: photoSettings.resolution,
                                                                         camera: camera,
                                                                         afterConstraints: resolutionConstraints)
        
        XCTAssertEqual(resolvedResolution, frameRateBestResolution, "Solved constrained resolution value correctly.")
    }
    
    func testDoubleConstrainedResolution() {
        let targetResolution = IntSize(width: 1920, height: 1080)
        let frameRateBestResolution = IntSize(width: 1280, height: 720)
        let burstSpeedBestResolution = IntSize(width: 640, height: 480)
        
        let targetBurstSpeed = 120
        let targetFrameRate = 30
        let photoSettings = PhotoSettings()
        photoSettings.frameRate = .custom(rate: targetFrameRate)
        photoSettings.resolution = .custom(width: targetResolution.width,
                                           height: targetResolution.height)
        photoSettings.burstSpeed = .custom(speed: targetBurstSpeed)
        
        photoSettings.priorities.items = [
            .burstSpeed,
            .frameRate,
            .resolution
        ]
        
        let camera = TestCamera(position: .back)
        camera.highestResolutionForFrameRateClosure = { frameRate in
            if frameRate == targetFrameRate {
                return frameRateBestResolution
            }
            return burstSpeedBestResolution
        }
        
        CurrentDevice.cameras = [camera]
        let resolver = photoSettings.constraintsResolver
        let resolutionConstraints = resolver.constraints(for: photoSettings.resolution)!
        
        XCTAssertEqual(resolutionConstraints.count, 1, "Correct amount of resolution constraints")
        let resolvedResolution = photoSettings.constraintsResolver.value(for: photoSettings.resolution,
                                                                         camera: camera,
                                                                         afterConstraints: resolutionConstraints)
        
        XCTAssertEqual(resolvedResolution, burstSpeedBestResolution, "Solved constrained resolution value correctly.")
        
        let frameRateConstraints = resolver.constraints(for: photoSettings.frameRate)!
        
        XCTAssertEqual(frameRateConstraints.count, 1, "Correct amount of frame rate constraints")
        let resolvedFrameRate = photoSettings.constraintsResolver.value(for: photoSettings.frameRate,
                                                                        camera: camera,
                                                                        afterConstraints: frameRateConstraints)
        
        XCTAssertEqual(resolvedFrameRate, targetBurstSpeed, "Solved constrained frame rate value correctly.")
    }
    
    func testBurstSpeedNotConstrained() {
        let targetBurstSpeed = 5
        let targetFrameRate = 30
        let photoSettings = PhotoSettings()
        photoSettings.frameRate = .custom(rate: targetFrameRate)
        photoSettings.resolution = .maximum
        photoSettings.burstSpeed = .custom(speed: targetBurstSpeed)
        
        photoSettings.priorities.items = [
            .resolution,
            .frameRate,
            .burstSpeed
        ]
        
        let camera = TestCamera(position: .back)
        camera.highestFrameRateForResolutionClosure = { resolution in
            return targetFrameRate
        }
        
        CurrentDevice.cameras = [camera]
        let resolver = photoSettings.constraintsResolver
        
        let burstSpeedConstraints = resolver.constraints(for: photoSettings.burstSpeed)
        
        XCTAssertNil(burstSpeedConstraints, "Burst speed should not be constrained")
    }
    
    func testBurstSpeedDoesntBringFrameRateUp() {
        let targetBurstSpeed = 120
        let targetFrameRate = 30
        let correctFrameRate = 20
        let photoSettings = PhotoSettings()
        photoSettings.frameRate = .custom(rate: targetFrameRate)
        photoSettings.resolution = .maximum
        photoSettings.burstSpeed = .custom(speed: targetBurstSpeed)
        
        photoSettings.priorities.items = [
            .resolution,
            .burstSpeed,
            .frameRate
        ]
        
        let camera = TestCamera(position: .back)
        camera.highestFrameRateForResolutionClosure = { resolution in
                return correctFrameRate
        }
        
        CurrentDevice.cameras = [camera]
        let resolver = photoSettings.constraintsResolver
        
        let frameRateConstraints = resolver.constraints(for: photoSettings.frameRate)!
        XCTAssertEqual(frameRateConstraints.count, 1, "Correct amount of frame rate constraints")
        let resolvedFrameRate = photoSettings.constraintsResolver.value(for: photoSettings.frameRate,
                                                                        camera: camera,
                                                                        afterConstraints: frameRateConstraints)
        
        XCTAssertEqual(resolvedFrameRate, correctFrameRate, "Solved constrained frame rate value correctly.")
    }
}
