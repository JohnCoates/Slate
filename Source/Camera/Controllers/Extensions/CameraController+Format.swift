//
//  CameraController+Format.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import AVFoundation

extension CameraController {
    
    func setBestFormat(for camera: DeviceCamera,
                       callAfterSessionRunning: inout (() -> Void)?) {
        let device = camera.device
        
        let format = self.bestFormat(for: camera)
        
        if !Platform.isProduction {
            print("Found format: \(format.deviceFormat)")
        }
        do {
            /* 
             https://developer.apple.com/reference/avfoundation/avcapturedevice/1387810-lockforconfiguration
             To prevent automatic changes to the capture format in macOS, follow these steps:
             - Lock the device with the lockForConfiguration() method.
             - Change the device’s activeFormat property.
             - Begin capture with the session’s startRunning() method.
             - Unlock the device with the unlockForConfiguration() method.
            */
            let range = format.range
            try device.lockForConfiguration()
            device.activeFormat = format.deviceFormat
            device.activeVideoMinFrameDuration = range.minFrameDuration
            device.activeVideoMaxFrameDuration = range.maxFrameDuration
            callAfterSessionRunning = {
                device.unlockForConfiguration()
            }
        } catch let error {
            print("error locking camera for configuration: \(error)")
        }
    }
    
    #if (iOS)
    
    private func bestFormat(for camera: DeviceCamera) -> Format {
        let resolver = kit.photoSettings.constraintsResolver
        let frameRate = resolver.frameRate(for: camera)
        let resolution = resolver.resolution(for: camera)
        
        let device = camera.device
        let formats = device.formats
        var bestFormat: AVCaptureDevice.Format?
        var frameRateRange: AVFrameRateRange?
        
        for format in formats {
            let ranges = format.videoSupportedFrameRateRanges
            let dimensions = format.dimensions
            
            guard dimensions == resolution else {
                continue
            }
            
            for range in ranges {
                guard Int(range.minFrameRate) <= frameRate && Int(range.maxFrameRate) >= frameRate else {
                    continue
                }
                
                bestFormat = format
                frameRateRange = range
            }
        }
        
        guard let format = bestFormat,
            let range = frameRateRange else {
                fatalError("Couldn't find best format for device!")
        }
        
        return Format(deviceFormat: format, range: range)
    }
    
    #else
    
    private func bestFormat(for camera: DeviceCamera) -> Format {
        let device = camera.device
        let formats = device.formats
        var bestFormat: AVCaptureDevice.Format?
        var frameRateRange: AVFrameRateRange?
        let targetFrameRate: Float64 = 30
        var bestWidth: Int32 = 0
        
        for format in formats {
            let formatDescription = format.formatDescription
            let ranges = format.videoSupportedFrameRateRanges
            let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
            let width = dimensions.width
            for range in ranges {
                if width >= bestWidth && range.maxFrameRate >= targetFrameRate {
                    bestWidth = width
                    bestFormat = format
                    frameRateRange = range
                }
            }
        }
        
        guard let format = bestFormat,
            let range = frameRateRange else {
                fatalError("Couldn't find best format for device")
        }
        
        return Format(deviceFormat: format, range: range)
    }
    
    #endif
    
    private struct Format {
        let deviceFormat: AVCaptureDevice.Format
        let range: AVFrameRateRange
    }
    
}
