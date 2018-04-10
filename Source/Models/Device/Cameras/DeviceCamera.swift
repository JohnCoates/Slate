//
//  DeviceCamera
//  Created on 4/7/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation
import AVFoundation

class DeviceCamera: Camera {
    
    let device: AVCaptureDevice
    
    init(device: AVCaptureDevice) {
        self.device = device
    }
    
    var userFacingName: String {
        if device.position == .front {
            return "Front Camera"
        } else {
            return "Back Camera"
        }
    }
    
    var description: String {
        return userFacingName
    }
    
    lazy var maximumResolution: IntSize = {
        var maximumResolution: IntSize = IntSize(width: 0, height: 0)
        for format in device.formats {
            let formatDescription = format.formatDescription
            let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
            
            if dimensions.width > maximumResolution.width ||
                dimensions.height > maximumResolution.height {
                maximumResolution = IntSize(dimensions)
            }
            
        }
        
        return maximumResolution
    }()
    
    lazy var maximumFrameRate: Int = {
        var highestFrameRate = 0
        let ranges = device.formats.flatMap { $0.videoSupportedFrameRateRanges }
        let highestMaybe = ranges.max { $0.maxFrameRate > $1.maxFrameRate }
        
        guard let highest = highestMaybe else {
            fatalError("Couldn't get highest frame rate")
        }
        
        return Int(highest.maxFrameRate)
    }()
    
    func highestResolution(forTargetFrameRate targetFrameRate: Int) -> IntSize? {
        let formats = device.formats
        let targetFrameRateFloat: Float64 = Float64(targetFrameRate)
        var maximumResolution: IntSize = IntSize(width: 0, height: 0)
        
        for format in formats {
            let formatDescription = format.formatDescription
            let ranges = format.videoSupportedFrameRateRanges
            let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
            
            for range in ranges {
                guard range.maxFrameRate >= targetFrameRateFloat else {
                    continue
                }
                if dimensions.width > maximumResolution.width ||
                    dimensions.height > maximumResolution.height {
                    maximumResolution = IntSize(dimensions)
                }
            }
        }
        
        if maximumResolution.width == 0 {
            return nil
        } else {
            return maximumResolution
        }
    }
    
}
