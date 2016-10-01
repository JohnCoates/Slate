//
//  MetalCaptureViewController.swift
//  Slate
//
//  Created by John Coates on 9/27/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit
import MetalKit

final class MetalCaptureViewController: BaseCaptureViewController {
    
    // MARK: - View Lifecycle
    
    lazy var metalView = MTKView()
    override func loadView() {
        view = metalView
    }
    
    // MARK: - Setup
    
    var renderer: Renderer!
    override func cameraSetup() {
        renderer = Renderer(metalView: metalView)
    }
    
    // MARK: - Capturing
    
    override func captureTapped() {
        print("metal capture")
    }
    
    // MARK: - Status Bar
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}
