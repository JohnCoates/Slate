//
//  CameraController.swift
//  Slate
//
//  Created by John Coates on 9/30/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import AVFoundation
#if os(iOS)
    import UIKit
#endif

class CameraController: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Configuration
    
    typealias CaptureHandler = (CVImageBuffer) -> Void
    private var captureHandler: CaptureHandler?
    func setCaptureHandler<T: AnyObject>(instance: T,
                                         method: @escaping (T) -> CaptureHandler) {
        captureHandler = {
            [unowned instance] imageBuffer in
            method(instance)(imageBuffer)
        }
    }
    
    // MARK: - Init / Deinit
    
    deinit {
        session.stopRunning()
    }
    
    // MARK: - Starting Up
    
    lazy var session = AVCaptureSession()
    
    var bestCamera: AVCaptureDevice {
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) else {
            fatalError("No video devices")
        }
        for potentialDevice in devices {
            guard let device = potentialDevice as? AVCaptureDevice else {
                continue
            }
            
            // prefer my logitech camera
            if device.localizedName == "HD Pro Webcam C920" {
                return device
            }
        }
        return AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    }
    
    lazy var stillOutput: AVCaptureStillImageOutput = {
        let capture = AVCaptureStillImageOutput()
        // same format as the preview video, stops the internal conversion
        // from dropping in FPS
        let format: [String: Any] = [
            String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_32BGRA as NSNumber
        ]
        capture.outputSettings = format
        return capture
    }()
    
    func startCapturingVideo() {
        session.beginConfiguration()
        
        guard let preset = bestSessionPreset() else {
            fatalError("Couldn't find settable video preset!")
        }
        
        session.sessionPreset = preset
        
        let camera = bestCamera
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            session.addInput(input)
        } catch {
            print("Couldn't instantiate device input")
            return
        }
        
        attachPreviewOutput(toSession: session)
        attachStillPhotoOutput(toSession: session)
//        setBestPreviewFormat(forDevice: camera)
        session.commitConfiguration()
        
        session.startRunning()
    }
    func bestSessionPreset() -> String? {
        let suitablePresets: [String]
        if Platform.isMacOS {
            suitablePresets = [AVCaptureSessionPreset1280x720]
        } else {
            suitablePresets = [
                AVCaptureSessionPresetiFrame960x540,
                AVCaptureSessionPreset1280x720,
                AVCaptureSessionPresetPhoto
                
            ]
        }
        for preset in suitablePresets {
            if session.canSetSessionPreset(preset) {
                return preset
            }
        }
        return nil
    }
    
    func attachPreviewOutput(toSession session: AVCaptureSession) {
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.alwaysDiscardsLateVideoFrames = true
        if !Platform.isProduction {
            printAvailableFormatTypes(forDataOutput: dataOutput)
        }
        dataOutput.videoSettings = captureVideoSettings
        
        // Set dispatch to be on the main thread to create the texture in memory
        // and allow Metal to use it for rendering
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        session.addOutput(dataOutput)
    }
    
    func attachStillPhotoOutput(toSession session: AVCaptureSession) {
        if session.canAddOutput(stillOutput) {
            session.addOutput(stillOutput)
        } else {
            print("Error: Couldn't add still output!")
        }
    }
    
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
    
    fileprivate var captureVideoSettings: [AnyHashable: Any] {
        let pixelFormatKey = String(kCVPixelBufferPixelFormatTypeKey)
        let pixelFormat = Int(kCVPixelFormatType_32BGRA)
        let metalCompatibilityKey = String(kCVPixelBufferMetalCompatibilityKey)
        
        var videoSettings = [AnyHashable: Any]()
        videoSettings[pixelFormatKey] = pixelFormat
        #if os(macOS)
            videoSettings[metalCompatibilityKey] = true
        #endif
        
        return videoSettings
    }
    
    // MARK: - Cameras
    
    func switchToNextCamera() {
        guard var devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] else {
            fatalError("No video devices")
        }
        if devices.count < 2 {
            print("Can't switch to next camera, only \(devices.count) cameras available")
            return
        }
        
        session.stopRunning()
        var currentDeviceMaybe: AVCaptureDevice?
        for input in session.inputs {
            guard let captureInput = input as? AVCaptureDeviceInput else {
                continue
            }
            currentDeviceMaybe = captureInput.device
            session.removeInput(captureInput)
        }
        
        guard let currentDevice = currentDeviceMaybe else {
            print("Can't switch to next camera, couldn't find current device as input")
            return
        }
        guard let currentDeviceIndex = devices.index(of: currentDevice) else {
            print("Can't switch to next camera, couldn't find current device in list")
            return
        }
        
        devices.remove(at: currentDeviceIndex)
        let device = devices[0]
        do {
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
        } catch {
            print("Couldn't instantiate device input")
            return
        }
        
        session.commitConfiguration()
        session.startRunning()
    }
    
    // MARK: - Video Delegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!) {
        #if METAL_DEVICE
            #if os(iOS)
            let orientation = UIApplication.shared.statusBarOrientation.rawValue
            connection.videoOrientation = AVCaptureVideoOrientation(rawValue: orientation)!
            #endif
            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                print("Couldn't get image buffer")
                return
            }
            
            captureHandler?(imageBuffer)
        #endif
    }
    
    // MARK: - Debug
    
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
