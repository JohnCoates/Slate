//
//  CameraController+Session.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import AVFoundation

extension CameraController {
    
    func startCapturingVideo() {
        session.beginConfiguration()
        
        let camera: DeviceCamera = Critical.cast(bestCamera)
        do {
            let input = try AVCaptureDeviceInput(device: camera.device)
            session.addInput(input)
        } catch {
            print("Couldn't instantiate device input")
            return
        }
        
        attachPreviewOutput(toSession: session)
        attachStillPhotoOutput(toSession: session)
        var callAfterSessionRunning: (() -> Void)?
        setBestFormat(for: camera,
                      callAfterSessionRunning: &callAfterSessionRunning)
        
        session.commitConfiguration()
        session.startRunning()
        callAfterSessionRunning?()
    }
    
}
