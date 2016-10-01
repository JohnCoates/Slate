//
//  CameraController.swift
//  Slate
//
//  Created by John Coates on 9/30/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import AVFoundation

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
    func startCapturingVideo() {
        session.beginConfiguration()
        
        session.sessionPreset = AVCaptureSessionPresetHigh
        let camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            session.addInput(input)
        } catch {
            print("Couldn't instantiate device input")
            return
        }
        
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
        session.commitConfiguration()
        session.startRunning()
    }
    
    fileprivate var captureVideoSettings: [AnyHashable: AnyObject] {
        get {
            let pixelFormatKey = String(kCVPixelBufferPixelFormatTypeKey)
            let pixelFormat = kCVPixelFormatType_32BGRA
            let metalCompatibilityKey = String(kCVPixelBufferMetalCompatibilityKey)
            
            var videoSettings = [AnyHashable: AnyObject]()
            videoSettings[pixelFormatKey] = NSNumber(value: pixelFormat)
            #if os(macOS)
                videoSettings[metalCompatibilityKey] = NSNumber(value: true)
            #endif
            
            return videoSettings
        }
    }
    
    // MARK: - Video Delegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!) {
        #if METAL_DEVICE
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
