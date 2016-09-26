//
//  CaptureViewController.swift
//  Slate
//
//  Created by John Coates on 9/25/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit
import AVFoundation
import Cartography
import GPUImage

class CaptureViewController: UIViewController {
    
    // MARK: - View Lifecycle
    
    var videoCamera: Camera?
    var captureView: RenderView!
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.black
        captureView = RenderView(frame: view.bounds)
        view.addSubview(captureView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraSetup()
        cameraCaptureViewSetup()
    }
    
    // MARK: - Camera Setup
    
    func cameraSetup() {
        do {
            videoCamera = try Camera(sessionPreset: AVCaptureSessionPresetPhoto)
        } catch {
            print("Couldn't initialize camera, error: \(error)")
            
        }
    }
    
    func cameraCaptureViewSetup() {
        guard let videoCamera = videoCamera else {
            return
        }
        
        videoCamera.addTarget(captureView)
        videoCamera.startCapture()
    }
}
