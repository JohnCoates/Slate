//
//  CameraController+Debug.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import AVFoundation

extension CameraController {
    func printAvailableFormatTypes(forDataOutput dataOutput: AVCaptureVideoDataOutput) {
        #if os(iOS)
            return
        #endif
        
        #if os(macOS)
            guard let formatTypes = dataOutput.availableVideoCVPixelFormatTypes else {
                print("no available format types!")
                return
            }
            
            for formatType in formatTypes {
                guard let type = formatType as? Int else {
                    continue
                }
                let intType = UInt32(type)
                let osType = UTCreateStringForOSType(intType).takeRetainedValue() as String
                print("available pixel format type: \(osType)")
            }
        #endif
    }
}
