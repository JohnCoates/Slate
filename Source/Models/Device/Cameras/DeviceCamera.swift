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
    
    var position: CameraPosition {
        switch device.position {
        case .back, .unspecified:
            return .back
        case .front:
            return .front
        }
    }
    
    var description: String {
        if device.position == .front {
            return "Front Camera"
        } else {
            return "Back Camera"
        }
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
        
        guard let highest = ranges.max(by: { $1.maxFrameRate > $0.maxFrameRate }) else {
            fatalError("Couldn't get highest frame rate")
        }
        
        return Int(highest.maxFrameRate)
    }()
    
    func highestResolution(forFrameRate targetFrameRate: Int) -> IntSize? {
        let targetFrameRateFloat: Float64 = Float64(targetFrameRate)
        var maximumResolution: IntSize = IntSize(width: 0, height: 0)
        
        for format in device.formats {
            let ranges = format.videoSupportedFrameRateRanges
            let dimensions = format.dimensions
            
            for range in ranges {
                guard range.maxFrameRate >= targetFrameRateFloat else {
                    continue
                }
                if dimensions.width > maximumResolution.width ||
                    dimensions.height > maximumResolution.height {
                    maximumResolution = dimensions
                }
            }
        }
        
        return discard(value: maximumResolution,
                       ifZero: maximumResolution.width)
    }
    
    func highestFrameRate(forResolution targetResolution: IntSize) -> Int? {
        var maximumFrameRate = 0
        for format in device.formats {
            let ranges = format.videoSupportedFrameRateRanges
            let dimensions = format.dimensions
            guard dimensions.width >= targetResolution.width && dimensions.height >= targetResolution.height else {
                continue
            }
            
            guard let bestRange = ranges.max(by: { $1.maxFrameRate > $0.maxFrameRate }) else {
                continue
            }
            
            maximumFrameRate = max(Int(bestRange.maxFrameRate), maximumFrameRate)
        }
        
        return discard(ifZero: maximumFrameRate)
    }
    
}
