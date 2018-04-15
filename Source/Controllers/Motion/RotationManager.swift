//
//  RotationManager
//  Created on 4/13/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreMotion

final class RotationManager {
    
    // MARK: - Public
    
    static let shared = RotationManager()
    static var requests: Int = 0
    
    static func beginOrientationEvents() {
        requests += 1
        if requests == 1 {
            shared.start()
        }
    }
    
    static func endOrientationEvents() {
        requests -= 1
        if requests == 0 {
            shared.stop()
        } else if requests < 0 {
            fatalError("Unbalanced call to \(#function)")
        }
    }
    
    // MARK: - Init
    
    private let queue = OperationQueue()
    private let motionManager = CMMotionManager()

    private init() {
        if !motionManager.isAccelerometerAvailable,
            Platform.isSimulator {
            print("No rotation events for simulator")
        }
    }
    
    // MARK: - Start, Stop
    
    var attitudeUpdated: ((CMAttitude) -> Void)?
    static var updateInterval = 0.2
    private func start() {
        guard motionManager.isAccelerometerAvailable else {
            print("Error: No accelerometer available!")
            return
        }
        motionManager.deviceMotionUpdateInterval = RotationManager.updateInterval
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: queue) { [unowned self] data, error in
            guard let data = data else {
                let error = Critical.unwrap(error)
                print("Error receiving accelerometer data: \(error)")
                return
            }

            let attitude = data.attitude
            self.attitudeUpdated?(data.attitude)
            
            let pitch = RotationManager.degrees(radians: attitude.pitch)
            let yaw = RotationManager.degrees(radians: attitude.yaw)
            let roll = RotationManager.degrees(radians: attitude.roll)
            self.interfaceOrientation = RotationManager.newOrientation(from: self.interfaceOrientation,
                                                                       pitch: pitch, yaw: yaw, roll: roll)
        }
    }
    
    private func stop() {
        motionManager.stopAccelerometerUpdates()
    }
    
    // MARK: - Calculate orientation
    
    static func degrees(radians: Double) -> Int {
        return Int(180 / Double.pi * radians)
    }
    
    static var orientation: UIInterfaceOrientation {
        return shared.interfaceOrientation
    }
    
    private var interfaceOrientation: UIInterfaceOrientation = .unknown
    
    // swiftlint:disable:next cyclomatic_complexity
    static func newOrientation(from previous: UIInterfaceOrientation,
                               pitch: Int, yaw: Int, roll: Int) -> UIInterfaceOrientation {
        
        let isPointingDown = { (roll: Int, pitch: Int) in
            return abs(roll) < 30 && abs(pitch) < 30
        }
        
        let isPointingUp = { (roll: Int, pitch: Int) in
            return abs(roll) > 150 && abs(pitch) < 40
        }
        
        if isPointingDown(roll, pitch) || isPointingUp(roll, pitch) {
            if case .unknown = previous {
                return .portrait
            }
            return previous
        }
        
        switch previous {
        case .landscapeRight, .landscapeLeft:
            if pitch > 50 {
                return .portrait
            } else if pitch < -50 {
                return .portraitUpsideDown
            }
        case .portrait:
            if pitch < 30 && roll < 0 {
                return .landscapeLeft
            } else if pitch < 30 && roll > 0 {
                return .landscapeRight
            }
        case .portraitUpsideDown:
            if pitch > -40 && roll < 0 {
                return .landscapeLeft
            } else if pitch > -40 && roll > 0 {
                return .landscapeRight
            }
            return .portraitUpsideDown
        case .unknown:
            if pitch > 30 {
                return .portrait
            } else if pitch < -50 {
                return .portraitUpsideDown
            } else if roll < 0 {
                return .landscapeLeft
            } else {
                return .landscapeRight
            }
        }
        
        return previous
    }
}
