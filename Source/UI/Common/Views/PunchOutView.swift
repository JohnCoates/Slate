//
//  PunchOutView.swift
//  Slate
//
//  Created by John Coates on 5/13/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography

final class PunchOutView: UIView {
    
    // MARK: - Init
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func initialSetup() {
        backgroundColor = UIColor(red:0.93, green:0.93,
                                  blue:0.93, alpha:0.59)
        layer.cornerRadius = 3.5
        setUpIconProxy()
    }
    
    let iconProxy = UIView(frame: .zero)
    func setUpIconProxy() {
        iconProxy.isHidden = false
        addSubview(iconProxy)
        var heightConstraint: NSLayoutConstraint?
        constrain(iconProxy) {
            let superview = $0.superview!
            $0.center == superview.center
            $0.width == 19
            heightConstraint = $0.height == ($0.width * heightRatio)
        }
        self.heightConstraint = heightConstraint
    }
    
    // MARK: - Icon
    
    let shape = CAShapeLayer()
    var heightRatio: CGFloat = 0.8665 {
        didSet {
            if let heightConstraint = heightConstraint {
                heightConstraint.setMultiplier(heightRatio)
            }
        }
    }
    
    var heightConstraint: NSLayoutConstraint?
    lazy var iconPath: CGPath = {
        let iconPath = UIBezierPath()
        iconPath.move(to: CGPoint(x: 92.22, y: 1.64))
        iconPath.addLine(to: CGPoint(x: 33.3, y: 75.61))
        iconPath.addLine(to: CGPoint(x: 7.76, y: 43.54))
        iconPath.addCurve(to: CGPoint(x: 1.63, y: 42.86), controlPoint1: CGPoint(x: 6.26, y: 41.66), controlPoint2: CGPoint(x: 3.52, y: 41.35))
        iconPath.addCurve(to: CGPoint(x: 0.95, y: 49.02), controlPoint1: CGPoint(x: -0.24, y: 44.37), controlPoint2: CGPoint(x: -0.55, y: 47.12))
        iconPath.addLine(to: CGPoint(x: 29.89, y: 85.35))
        iconPath.addCurve(to: CGPoint(x: 33.3, y: 87), controlPoint1: CGPoint(x: 30.72, y: 86.39), controlPoint2: CGPoint(x: 31.98, y: 87))
        iconPath.addCurve(to: CGPoint(x: 36.71, y: 85.35), controlPoint1: CGPoint(x: 34.63, y: 87), controlPoint2: CGPoint(x: 35.88, y: 86.4))
        iconPath.addLine(to: CGPoint(x: 99.04, y: 7.11))
        iconPath.addCurve(to: CGPoint(x: 98.36, y: 0.95), controlPoint1: CGPoint(x: 100.54, y: 5.22), controlPoint2: CGPoint(x: 100.25, y: 2.47))
        iconPath.addCurve(to: CGPoint(x: 92.22, y: 1.64), controlPoint1: CGPoint(x: 96.48, y: -0.55), controlPoint2: CGPoint(x: 93.74, y: -0.25))
        iconPath.addLine(to: CGPoint(x: 92.22, y: 1.64))
        iconPath.close()

        return iconPath.cgPath
    }()
    
    // MARK: - Masking
    
    func updateMask(withFrame frame: CGRect, inverse: Bool = true) {
        let scale = frame.size.width / 100.0
        let translationFactor = 100 / frame.size.width
        
        var affineTransform = CGAffineTransform.init(scaleX: scale, y: scale)
        affineTransform = affineTransform.translatedBy(x: frame.origin.x * translationFactor, y: frame.origin.y * translationFactor)
        guard let transformedPath = iconPath.copy(using: &affineTransform) else {
            fatalError("Couldn't make path mutable!")
        }

        
        let maskPath = CGMutablePath()
        
        if (inverse) {
            maskPath.addRect(self.bounds)
        }
        maskPath.addPath(transformedPath)
        
        shape.fillRule = kCAFillRuleEvenOdd
        shape.path = maskPath

        layer.mask = shape
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask(withFrame: iconProxy.frame)
    }
}
