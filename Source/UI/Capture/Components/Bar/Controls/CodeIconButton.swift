//
//  CodeIconButton.swift
//  Slate
//
//  Created by John Coates on 5/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography

class CodeIconButton: Button {
    
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
    
    override func initialSetup() {
        super.initialSetup()
        backgroundColor = UIColor(red:0.93, green:0.93,
                                  blue:0.93, alpha:0.59)
        layer.addSublayer(shape)
        shape.fillColor = UIColor.white.cgColor
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
    
    func updatePath(withFrame frame: CGRect) {
        let scale = frame.size.width / icon.width
        let translationFactor = icon.width / frame.size.width
        
        var affineTransform = CGAffineTransform.init(scaleX: scale, y: scale)
        affineTransform = affineTransform.translatedBy(x: frame.origin.x * translationFactor,
                                                       y: frame.origin.y * translationFactor)
        
        guard let transformedPath = icon.path.copy(using: &affineTransform) else {
            fatalError("Couldn't make path mutable!")
        }
        
        shape.path = transformedPath
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath(withFrame: iconProxy.frame)
    }
}
