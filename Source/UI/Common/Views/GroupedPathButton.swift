//
//  GroupedPathButton
//  Slate
//
//  Created by John Coates on 5/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography

class GroupedPathButton: Button {
    
    // MARK: - Init
    
    let icon: GroupedPathIcon
    
    init(icon: GroupedPathIcon) {
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
        setUpIconProxy()
        setUpShapes()
    }
    
    func setUpShapes() {
        for _ in 0..<icon.paths.count {
            let shape = CAShapeLayer()
            shapes.append(shape)
            layer.addSublayer(shape)
            shape.fillColor = UIColor.white.cgColor
        }
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
    
    var shapes = [CAShapeLayer]()
    
    func updatePaths(withFrame frame: CGRect) {
        for index in 0..<icon.paths.count {
            let shape = shapes[index]
            let path = icon.paths[index]
            shape.path = transformed(path: path, forFrame: frame)
        }
    }
    
    func transformed(path: CGPath, forFrame frame: CGRect) -> CGPath {
        let scale = frame.size.width / icon.width
        let translationFactor = icon.width / frame.size.width
        
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
