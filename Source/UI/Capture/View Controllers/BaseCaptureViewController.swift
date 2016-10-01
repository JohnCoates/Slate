//
//  BaseCaptureViewController.swift
//  Slate
//
//  Created by John Coates on 9/30/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit
import Cartography

class BaseCaptureViewController: UIViewController {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "CaptureView"
        view.backgroundColor = UIColor.black
        controlsSetup()
        
        if Platform.isSimulator {
            placeholderSetup()
        } else {
            cameraSetup()
        }
    }
    
    // MARK: - Setup
    
    func cameraSetup() {
        fatalError("\(#file) cameraSetup() must be subclassed")
    }
    
    // MARK: - Placeholder
    
    fileprivate func placeholderSetup() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "HannahDeathValley"))
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.insertSubview(imageView, at: 0)
    }
    
    // MARK: - Controls Setup
    
    private lazy var captureButton: CaptureButton = CaptureButton()
    fileprivate func controlsSetup() {
        captureButton.setTappedCallback(instance: self,
                                        method: Method.captureTapped)
        view.addSubview(captureButton)
        
        constrain(captureButton) {
            let superview = $0.superview!
            $0.width == 75
            $0.height == $0.width
            $0.centerX == superview.centerX
            $0.bottom == superview.bottom - 15
        }
    }
    
    // MARK: - Capturing
    
    func captureTapped() {
        print("capture tapped")
    }
    
    // MARK: - Status Bar
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}

// MARK: - Callbacks

fileprivate struct Method {
    static let captureTapped = BaseCaptureViewController.captureTapped
    
}
