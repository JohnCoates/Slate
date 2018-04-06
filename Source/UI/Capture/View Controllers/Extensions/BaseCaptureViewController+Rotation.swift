//
//  BaseCaptureViewController+Rotation.swift
//  Slate
//
//  Created by John Coates on 5/20/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

extension BaseCaptureViewController {
    
    func applyUprightTransformToSubscribedViews() {
        let orientation = UIApplication.shared.statusBarOrientation
        for view in keepUpright {
            applyUprightTransform(forOrientation: orientation, toView: view)
        }
    }
    
    func applyUprightTransform(forOrientation orientation: UIInterfaceOrientation,
                               toView view: UIView) {
        var transform = CGAffineTransform.identity
        
        switch orientation {
        case .portrait:
            break
        case .portraitUpsideDown:
            transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        case .landscapeLeft:
            transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        case .landscapeRight:
            transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        case .unknown:
            return
        }
        
        view.transform = transform
    }
    
    func rootViewRoundTransformNowThatAnimationFinished() {
        var currentTransform = view.transform
        currentTransform.a = round(currentTransform.a)
        currentTransform.b = round(currentTransform.b)
        currentTransform.c = round(currentTransform.c)
        currentTransform.d = round(currentTransform.d)
        view.transform = currentTransform
    }
    
    func rootViewUpdateBounds(oldBounds: CGRect, targetSize: CGSize) {
        var newBounds = oldBounds
        let wasLandscape = oldBounds.width > oldBounds.height
        
        let landscapeTarget = targetSize.width > targetSize.height
        let transitioningFromOrientationSize = landscapeTarget != wasLandscape
        if transitioningFromOrientationSize {
            newBounds.size = CGSize.init(width: targetSize.height, height: targetSize.width)
        }
        
        view.bounds = newBounds
    }
    
    func rootViewApplyRotationCorrectingTransform(targetTransform: CGAffineTransform) {
        guard let currentRotationZ = view.layer.value(forKeyPath: "transform.rotation.z") as? Double else {
            let layer = view.layer
            fatalError("Couldn't get rotation.z for root view with layer \(layer)")
        }
        let opposingAngle = atan2(Double(targetTransform.b), Double(targetTransform.a))
        // Without this workaround in place, rotations can take the long way to our target rotation
        let closestRotationWorkaround: Double = 0.0001
        let newRotationZ = currentRotationZ + (opposingAngle * -1) + closestRotationWorkaround
        view.layer.setValue(newRotationZ, forKeyPath: "transform.rotation.z")
    }
    
}
