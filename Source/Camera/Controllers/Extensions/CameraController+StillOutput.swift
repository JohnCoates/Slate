//
//  CameraController+StillOutput.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import AVFoundation

extension CameraController {
    
    // MARK: - Create 
    
    func buildStillOutput() -> AVCaptureStillImageOutput {
        let capture = AVCaptureStillImageOutput()
        // same format as the preview video, stops the internal conversion
        // from dropping in FPS
        let format: [String: Any] = [
            String(kCVPixelBufferPixelFormatTypeKey): previewPixelFormat
        ]
        capture.outputSettings = format
        return capture
    }
    
    // MARK: - Attaching
    
    func attachStillPhotoOutput(toSession session: AVCaptureSession) {
        if session.canAddOutput(stillOutput) {
            session.addOutput(stillOutput)
        } else {
            print("Error: Couldn't add still output!")
        }
    }
    
}
