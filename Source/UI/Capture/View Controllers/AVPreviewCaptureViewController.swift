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
    
    lazy var cameraController = CameraController()
    lazy var session = AVCaptureSession()
    
    override func cameraSetup() {
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            try session.addInput(AVCaptureDeviceInput(device: device))
        } catch let error {
            print("error: \(error)")
            return
        }
        
        let previewView = UIView()
        previewView.accessibilityIdentifier = "AVPreview"
        previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        previewView.frame = view.bounds
        view.addSubview(previewView)
        
        guard let layer = AVCaptureVideoPreviewLayer(session: session) else {
            fatalError("Failed to create video preview layer instance")
        }
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer.frame = previewView.bounds
        previewView.layer.addSublayer(layer)
        
        session.commitConfiguration()
        session.startRunning()
    }
    
}
