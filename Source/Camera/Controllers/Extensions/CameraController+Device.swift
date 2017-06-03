//
//  CameraController+Device.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import AVFoundation

extension CameraController {
    var bestCamera: AVCaptureDevice {
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) else {
            fatalError("No video devices")
        }
        for potentialDevice in devices {
            guard let device = potentialDevice as? AVCaptureDevice else {
                continue
            }
            // prefer my logitech camera
            if device.localizedName.hasPrefix("HD Pro Webcam C920") {
                return device
            }
        }
        return AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    }

    
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

}
