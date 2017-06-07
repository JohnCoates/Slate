//
//  CodeIconButton.swift
//  Slate
//
//  Created by John Coates on 5/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

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
        contentView.backgroundColor = UIColor(red:0.93, green:0.93,
                                              blue:0.93, alpha:0.59)
        setUpIconProxy()
        setUpShape()
    }
    
    func setUpShape() {
        contentView.layer.addSublayer(shape)
        shape.fillColor = UIColor.white.cgColor
    }
    
    let iconProxy = UIView(frame: .zero)
    func setUpIconProxy() {
        iconProxy.isHidden = true
        contentView.addSubview(iconProxy)
        
        let heightRatio = icon.height / icon.width
        iconProxy.centerXY --> contentView.centerXY
        iconProxy.width --> 19
        iconProxy.height.pin(to: iconProxy.width, times: heightRatio)
    }
    
    // MARK: - Icon
    
    let shape = CAShapeLayer()
    
    func updatePath(withFrame frame: CGRect) {
        shape.path = transformedPath(forFrame: frame)
    }
    
    func transformedPath(forFrame frame: CGRect) -> CGPath {
        let scale = frame.size.width / icon.width
        let translationFactor = icon.width / frame.size.width
        
        var affineTransform = CGAffineTransform.init(scaleX: scale, y: scale)
        affineTransform = affineTransform.translatedBy(x: frame.origin.x * translationFactor,
                                                       y: frame.origin.y * translationFactor)
        
        guard let transformedPath = icon.path.copy(using: &affineTransform) else {
            fatalError("Couldn't make path mutable!")
        }
        return transformedPath
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        handlePathLayout(forFrame: iconProxy.frame)
    }
    
    func handlePathLayout(forFrame frame: CGRect) {
        updatePath(withFrame: frame)
    }
}
