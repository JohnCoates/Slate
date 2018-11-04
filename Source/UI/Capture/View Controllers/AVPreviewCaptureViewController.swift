//
//  AVPreviewCaptureViewController.swift
//  Slate
//
//  Created by John Coates on 5/30/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import AVFoundation

class AVPreviewCaptureViewController: BaseCaptureViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    lazy var cameraController = CameraController(kit: self.kit)
    lazy var session = AVCaptureSession()
    
    override func cameraSetup() {
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.photo
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Couldn't get ddefault capture device")
            return
        }
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: device)
            session.addInput(captureDeviceInput)
        } catch let error {
            print("error: \(error)")
            return
        }
        
        let previewView = UIView()
        previewView.accessibilityIdentifier = "AVPreview"
        previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        previewView.frame = view.bounds
        view.addSubview(previewView)
        
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.frame = previewView.bounds
        previewView.layer.addSublayer(layer)
        
        session.commitConfiguration()
        session.startRunning()
    }
    
}
