//
//  InverseMaskButton.swift
//  Slate
//
//  Created by John Coates on 5/13/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography

final class InverseMaskButton: UIButton {
    
    // MARK: - Init
    
    let icon: PathIcon
    
    init(icon: PathIcon) {
        self.icon = icon
        super.init(frame: .zero)
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
        iconProxy.isHidden = true
        addSubview(iconProxy)
        
        let heightRatio = icon.height / icon.width
        constrain(iconProxy) {
            let superview = $0.superview!
            $0.center == superview.center
            $0.width == 19
            $0.height == $0.width * heightRatio
        }
    }
    
    // MARK: - Icon
    
    let shape = CAShapeLayer()
    
    // MARK: - Masking
    
    func updateMask(withFrame frame: CGRect, inverse: Bool = true) {
        let scale = frame.size.width / icon.width
        let translationFactor = icon.width / frame.size.width
        
        var affineTransform = CGAffineTransform.init(scaleX: scale, y: scale)
        affineTransform = affineTransform.translatedBy(x: frame.origin.x * translationFactor,
                                                       y: frame.origin.y * translationFactor)
        
        guard let transformedPath = icon.path.copy(using: &affineTransform) else {
            fatalError("Couldn't make path mutable!")
        }

        let maskPath = CGMutablePath()
        
        if inverse {
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
