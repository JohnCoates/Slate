//
//  CaptureButton.swift
//  Slate
//
//  Created by John Coates on 9/26/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit

class CaptureButton: Button {
    
    // MARK: - Setup
    
    override func initialSetup() {
        super.initialSetup()
        backgroundColor = UIColor.white
        alpha = 0.56
        accessibilityIdentifier = "CaptureButton"
        startJitter()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        layer.cornerRadius = frame.width / 2
//        layer.cornerRadius = frame.width / 1.05
        layer.cornerRadius = 8
    }
    
    func startJitter() {
        let position = jitterPositionAnimation()
        layer.add(position, forKey: "positionAnimation")
        
        let transform = jitterTransformAnimationKeyTimes()
        layer.add(transform, forKey: "transformAnimation")
    }
    
    func jitterPositionAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.duration = 0.25
        animation.isAdditive = true
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        
        var values = [Any]()
        values.append(NSValue(cgPoint: CGPoint(x: -1, y: -1)))
        values.append(NSValue(cgPoint: CGPoint(x: 0, y: 0)))
        values.append(NSValue(cgPoint: CGPoint(x: -1, y: -1)))
        values.append(NSValue(cgPoint: CGPoint(x: -1, y: -1)))
        animation.values = values
        animation.beginTime = 5
        animation.frameInterval = 0.05
        
        return animation
    }
    
    private func jitterTransformAnimationSpringBoard() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform"
        let function = CAValueFunction(name: kCAValueFunctionRotateZ)
        animation.valueFunction = function
        
        animation.isAdditive = true
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        var values = [Any]()
        values.append(NSNumber(value: -0.0352556))
        values.append(NSNumber(value: 0.0352556))
        values.append(NSNumber(value: -0.0352556))
        animation.values = values
        animation.frameInterval = 0.05
        animation.beginTime = 0
        
        return animation
    }
    
    private func jitterTransformAnimationKeyTimes() -> CAKeyframeAnimation {
        let interval = 0.0
        let duration = 0.5
        let frames = 6.0
        
        let totalDuration = interval + duration
        let frameDuration = duration / frames
        let frameTime = frameDuration / totalDuration
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform"
        let function = CAValueFunction(name: kCAValueFunctionRotateZ)
        animation.valueFunction = function
        
        animation.isAdditive = true
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        var values = [Any]()
        values.append(NSNumber(value: -0.0352556))
        values.append(NSNumber(value: 0.0352556))
        values.append(NSNumber(value: -0.0352556))
        animation.values = values
        
        var keyTimes = [NSNumber]()
        keyTimes.append(NSNumber(value: 0))
        keyTimes.append(NSNumber(value: frameTime * 3))
        keyTimes.append(NSNumber(value: frameTime * 5))
        animation.keyTimes = keyTimes
//        animation.frameInterval = 0.05
        animation.beginTime = 0
        
        return animation
    }
}
