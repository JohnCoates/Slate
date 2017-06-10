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
    
    func setBestFormat(forDevice device: AVCaptureDevice,
                       callAfterSessionRunning: inout (() -> Void)?) {
        guard let formats = device.formats as? [AVCaptureDeviceFormat] else {
            print("Couldn't get formats for device: \(device)")
            return
        }
        var bestFormat: AVCaptureDeviceFormat?
        var frameRateRange: AVFrameRateRange?
        let targetFrameRate: Float64 = 30
        var bestWidth: Int32 = 0
        var dimensionsMaybe: CMVideoDimensions?
        
        for format in formats {
            guard let formatDescription = format.formatDescription,
                let ranges = format.videoSupportedFrameRateRanges as? [AVFrameRateRange] else {
                    continue
            }
            let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
            let width = dimensions.width
            for range in ranges {
                if width >= bestWidth && range.maxFrameRate >= targetFrameRate {
                    bestWidth = width
                    bestFormat = format
                    frameRateRange = range
                    dimensionsMaybe = dimensions
                }
            }
        }
        
        guard let format = bestFormat,
            let range = frameRateRange,
            let dimensions = dimensionsMaybe else {
            print("Couldn't find best format for device")
            return
        }
        inputSize = Size(width: Float(dimensions.width),
                         height: Float(dimensions.height))
        if !Platform.isProduction {
            print("Found format with size: \(dimensions.width)x\(dimensions.height), frame rate: \(range)")
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
            try device.lockForConfiguration()
            device.activeFormat = format
            device.activeVideoMinFrameDuration = range.minFrameDuration
            device.activeVideoMaxFrameDuration = range.maxFrameDuration
            callAfterSessionRunning = {
                device.unlockForConfiguration()
            }
        } catch let error {
            print("error locking camera for configuration: \(error)")
        }
    }
    
    func format(withFrameRate: Float64, fromFormats formats: [AVCaptureDeviceFormat]) -> AVCaptureDeviceFormat? {
        return nil
    }
    
}
