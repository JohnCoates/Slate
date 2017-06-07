//
//  InverseMaskButton.swift
//  Slate
//
//  Created by John Coates on 5/13/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

final class InverseMaskButton: CodeIconButton {
    
    // MARK: - Setup
    
    override func initialSetup() {
        super.initialSetup()
        rounding = 0.3
    }
    
    override func setUpShape() {
        shape.fillRule = kCAFillRuleEvenOdd
        layer.mask = shape
    }
    
    // MARK: - Masking
    
    func updateMask(withFrame frame: CGRect, inverse: Bool = true) {
        let maskPath = CGMutablePath()
        
        if inverse {
            maskPath.addRect(self.bounds)
        }
        
        let transformedPath = self.transformedPath(forFrame: frame)
        maskPath.addPath(transformedPath)
        shape.path = maskPath
    }
    
    // MARK: - Layout
    
    override func handlePathLayout(forFrame frame: CGRect) {
        updateMask(withFrame: frame)
    }
}
