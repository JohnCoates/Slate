//
//  CurrentDevice
//  Created on 4/7/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation
import AVFoundation

class CurrentDevice {
    private static let shared = CurrentDevice()
    
    private init() {
    }
    
    static var cameras: [Camera] {
        return shared.cameras
    }
    
    private lazy var cameras: [Camera] = {
        let captureDevice = AVCaptureDevice.devices(for: .video)
        var cameras = [Camera]()
        
        for captureDevice in captureDevice {
            let camera = Camera(device: captureDevice)
            cameras.append(camera)
        }
        
        return cameras
    }()
}
