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
    var bestCamera: Camera {
        for camera in CurrentDevice.cameras {
            // prefer back camera
            if case .back = camera.position {
                return camera
            }
        }
        return Critical.unwrap(CurrentDevice.cameras.first)
    }
    
    func switchToNextCamera() {
        var devices = AVCaptureDevice.devices(for: AVMediaType.video)
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
        guard let currentDeviceIndex = devices.firstIndex(of: currentDevice) else {
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
