//
//  CaptureViewController.swift
//  Slate
//
//  Created by John Coates on 9/25/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit
import AVFoundation

final class SimulatorCaptureViewController: BaseCaptureViewController {

    // MARK: - Camera Setup

    override func cameraSetup() {
        let imageView = UIImageView(image:#imageLiteral(resourceName: "kylie"))
        imageView.contentMode = .scaleAspectFill
        view.insertSubview(imageView, at: 0)
        imageView.edges --> view.edges
    }

    // MARK: - Capturing

    override func capture() {
        print("simulator capture tapped")
    }
    
}
