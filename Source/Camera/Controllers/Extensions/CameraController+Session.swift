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
        var callAfterSessionRunning: (() -> Void)? = nil
        setBestFormat(forDevice: camera,
                      callAfterSessionRunning: &callAfterSessionRunning)
        
        session.commitConfiguration()
        session.startRunning()
        callAfterSessionRunning?()
    }
    
}
