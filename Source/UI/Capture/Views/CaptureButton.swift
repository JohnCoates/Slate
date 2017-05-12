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
    }
    
    var roundingPercentage: Float = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        layer.cornerRadius = frame.width / 2
//        layer.cornerRadius = frame.width / 1.05
//        layer.cornerRadius = 8
        layer.cornerRadius = (frame.width / 2) * CGFloat(roundingPercentage)
    }
    
    enum Animation: String {
        case position = "positionAnimation"
        case transform = "transformAnimation"
    }    
    
    func startKeyTimesJitter() {
        removeOldAnimations()
        
        let position = jitterPositionAnimation()
        layer.add(position,
                  forKey: Animation.position.rawValue)
        
        let transform = jitterTransformAnimationKeyTimes()
        layer.add(transform,
                  forKey: Animation.transform.rawValue)
    }
    
    func startFrameIntervalJitter() {
        removeOldAnimations()
        
        let position = jitterPositionAnimation()
        layer.add(position,
                  forKey: Animation.position.rawValue)
        
        let transform = jitterTransformAnimationFrameInterval()
        layer.add(transform,
                  forKey: Animation.transform.rawValue)
    }
    
    func stopJittter() {
        removeOldAnimations()
    }
    
    private func removeOldAnimations() {
        layer.removeAnimation(forKey: Animation.position.rawValue)
        layer.removeAnimation(forKey: Animation.transform.rawValue)
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
    
    private func jitterTransformAnimationFrameInterval() -> CAKeyframeAnimation {
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
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform"
        let function = CAValueFunction(name: kCAValueFunctionRotateZ)
        animation.valueFunction = function
        
        animation.isAdditive = true
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        var values = [Any]()
        values.append(NSNumber(value: -0.0352556))
        values.append(NSNumber(value: 0.0352556))
        values.append(NSNumber(value: -0.0352556))
        animation.values = values
        
        var keyTimes = [NSNumber]()
        keyTimes.append(NSNumber(value: 0))
        keyTimes.append(NSNumber(value: 0.5))
        keyTimes.append(NSNumber(value: 1))
        animation.keyTimes = keyTimes
        animation.beginTime = 0
        animation.duration = 0.25
        
        return animation
    }
}
