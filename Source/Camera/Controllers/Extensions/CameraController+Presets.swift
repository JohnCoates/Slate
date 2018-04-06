//
//  CameraController+Presets.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import AVFoundation

extension CameraController {
    
    func bestSessionPreset() -> AVCaptureSession.Preset? {
        let suitablePresets: [AVCaptureSession.Preset]
        if Platform.isMacOS {
            suitablePresets = [AVCaptureSession.Preset.hd1280x720]
        } else {
            suitablePresets = [
                AVCaptureSession.Preset.iFrame960x540,
                AVCaptureSession.Preset.hd1280x720,
                AVCaptureSession.Preset.photo   
            ]
        }
        for preset in suitablePresets {
            if session.canSetSessionPreset(preset) {
                return preset
            }
        }
        return nil
    }

}
