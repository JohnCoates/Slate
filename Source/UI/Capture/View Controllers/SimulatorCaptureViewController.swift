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

    override func placeholderSetup() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "HannahDeathValley"))
        imageView.contentMode = .scaleAspectFill
        view.insertSubview(imageView, at: 0)
        constrain(imageView) {
            let superview = $0.superview!
            $0.edges == superview.edges
        }
    }

    // MARK: - Capturing

    override func captureTapped() {
        print("simulator capture tapped")
    }
}
