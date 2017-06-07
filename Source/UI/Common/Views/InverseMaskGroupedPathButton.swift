//
//  InverseMaskGroupedPathButton.swift
//  Slate
//
//  Created by John Coates on 5/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class InverseMaskGroupedPathButton: GroupedPathButton {
    
    // MARK: - Setup
    
    override func initialSetup() {
        super.initialSetup()
        rounding = 0.3
    }
    
    let shape = CAShapeLayer()
    
    override func setUpShapes() {
        shape.fillRule = kCAFillRuleEvenOdd
        layer.mask = shape
    }
    
    // MARK: - Masking
    
    func updateMask(withFrame frame: CGRect, inverse: Bool = true) {
        let maskPath = CGMutablePath()
        
        if inverse {
            maskPath.addRect(self.bounds)
        }
        for path in icon.paths {
            let transformedPath = self.transformed(path: path, forFrame: frame)
            maskPath.addPath(transformedPath)
        }
        shape.path = maskPath
    }
    
    // MARK: - Layout
    
    override func handlePathLayout(forFrame frame: CGRect) {
        updateMask(withFrame: frame)
    }
}
