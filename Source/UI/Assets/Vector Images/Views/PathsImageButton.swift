//
//  PathsImageButton.swift
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class PathsImageButton: Button {
    
    // MARK: - Init
    
    var canvas: Canvas
    var paths: [CGPath]
    var pathsColor: UIColor = UIColor.white
    
    convenience init(asset: ImageAsset) {
        self.init(canvas: Canvas.from(asset: asset))
    }
    
    init(canvas: Canvas) {
        self.canvas = canvas
        self.paths = canvas.cgPaths()
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    override func initialSetup() {
        super.initialSetup()
        rounding = 0.3
        contentView.backgroundColor = UIColor(red:0.93, green:0.93,
                                              blue:0.93, alpha:0.59)
        setUpIconProxy()
        setUpShapes()
    }
    
    var shapes = [CAShapeLayer]()
    func setUpShapes() {
        for _ in 0..<paths.count {
            let shape = CAShapeLayer()
            shapes.append(shape)
            contentView.layer.addSublayer(shape)
            shape.fillColor = pathsColor.cgColor
        }
    }
    
    // ratio of width to superview
    var iconWidthRatio: CGFloat? {
        didSet {
            if let widthRatio = iconWidthRatio,
                let widthConstraint = iconProxy.constraintWithAttribute(.width) {
                NSLayoutConstraint.deactivate([widthConstraint])
                iconProxy.width.pin(to: contentView.width, times: widthRatio)
            }
        }
    }
    
    let iconProxy = UIView(frame: .zero)
    func setUpIconProxy() {
        iconProxy.isHidden = true
        contentView.addSubview(iconProxy)
        
        let heightRatio = CGFloat(canvas.height) / CGFloat(canvas.width)
        iconProxy.centerXY --> contentView.centerXY
        if let widthRatio = self.iconWidthRatio {
            iconProxy.width.pin(to: contentView.width, times: widthRatio)
        } else {
            iconProxy.width --> 19
        }
        iconProxy.height.pin(to: iconProxy.width, times: heightRatio)
    }
    
    // MARK: - Icon
    
    func updatePaths(withFrame frame: CGRect) {
        for index in 0..<paths.count {
            let shape = shapes[index]
            let path = paths[index]
            shape.path = transformed(path: path, forFrame: frame)
        }
    }
    
    func transformed(path: CGPath, forFrame frame: CGRect) -> CGPath {
        let scale = frame.size.width / CGFloat(canvas.width)
        let translationFactor = CGFloat(canvas.width) / frame.size.width
        
        var affineTransform = CGAffineTransform.init(scaleX: scale, y: scale)
        affineTransform = affineTransform.translatedBy(x: frame.origin.x * translationFactor,
                                                       y: frame.origin.y * translationFactor)
        
        guard let transformedPath = path.copy(using: &affineTransform) else {
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
        updatePaths(withFrame: frame)
    }
}
