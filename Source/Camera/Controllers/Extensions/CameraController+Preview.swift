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
    
    // MARK: - Active Format
    
    func setBestPreviewFormat(forDevice device: AVCaptureDevice) {
        guard let formats = device.formats as? [AVCaptureDeviceFormat] else {
            print("Couldn't get formats for device: \(device)")
            return
        }
        
        var bestFormat: AVCaptureDeviceFormat?
        var frameRateRange: AVFrameRateRange?
        var bestWidth: Int32 = 0
        let targetFrameRate: Float64 = 30
        let targetWidth: Int32 = 1280
        
        for format in formats {
            guard let formatDescription = format.formatDescription,
                let ranges = format.videoSupportedFrameRateRanges as? [AVFrameRateRange] else {
                    continue
            }
            let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
            let width = dimensions.width
            for range in ranges {
                if width > targetWidth {
                    continue
                }
                if width >= bestWidth && range.maxFrameRate >= targetFrameRate {
                    bestWidth = width
                    bestFormat = format
                    frameRateRange = range
                }
            }
        }
        
        guard let format = bestFormat, let range = frameRateRange else {
            print("Couldn't find best preview format for device")
            return
        }
        do {
            try device.lockForConfiguration()
            device.activeFormat = format
            device.activeVideoMinFrameDuration = range.minFrameDuration
            device.activeVideoMaxFrameDuration = range.maxFrameDuration
            device.unlockForConfiguration()
        } catch let error {
            print("error locking camera for configuration: \(error)")
        }
    }
}
