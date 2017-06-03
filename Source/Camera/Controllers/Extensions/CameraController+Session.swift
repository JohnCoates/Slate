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
}
