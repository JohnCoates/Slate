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

}
