//
//  CameraController+Preview.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import AVFoundation

extension CameraController {
    
    var previewPixelFormat: Int {
        return Int(kCVPixelFormatType_32BGRA)
    }
    
    var captureVideoSettings: [AnyHashable: Any] {
        let pixelFormatKey = String(kCVPixelBufferPixelFormatTypeKey)
        let pixelFormat = previewPixelFormat
        let metalCompatibilityKey = String(kCVPixelBufferMetalCompatibilityKey)
        
        var videoSettings = [AnyHashable: Any]()
        videoSettings[pixelFormatKey] = pixelFormat
        #if os(macOS)
            videoSettings[metalCompatibilityKey] = true
        #endif
        
        return videoSettings
    }
    
    func attachPreviewOutput(toSession session: AVCaptureSession) {
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.alwaysDiscardsLateVideoFrames = true
        if !Platform.isProduction {
            //            printAvailableFormatTypes(forDataOutput: dataOutput)
        }
        dataOutput.videoSettings = captureVideoSettings
        
        // Set dispatch to be on the main thread to create the texture in memory
        // and allow Metal to use it for rendering
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        session.addOutput(dataOutput)
    }
    
}
