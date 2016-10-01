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

final class SimulatorCaptureViewController: BaseCaptureViewController {

    // MARK: - Camera Setup

    override func cameraSetup() {
        placeholderSetup()
    }

    fileprivate func placeholderSetup() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "HannahDeathValley"))
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.insertSubview(imageView, at: 0)
    }

    // MARK: - Capturing

    override func captureTapped() {
        print("simulator capture tapped")
    }
}
