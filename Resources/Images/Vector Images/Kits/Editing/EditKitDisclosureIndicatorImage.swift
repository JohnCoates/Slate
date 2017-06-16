//
//  EditKitDisclosureIndicator.swift
//  Slate
//
//  Created by John Coates on 6/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension DrawProxyDSL {
    class EditKitDisclosureIndicator: VectorImageAsset {
        
        let asset = KitImage.disclosureIndicator
        lazy var name: String = self.asset.rawValue
        lazy var section: String = self.asset.section
        
        let width: CGFloat = 16
        let height: CGFloat = 26
        
        func simulateDraw() {
            //// Color Declarations
            let fillColor12 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
            
            //// Bezier Drawing
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 15.95, y: 13))
            bezierPath.addLine(to: CGPoint(x: 16, y: 12.95))
            bezierPath.addLine(to: CGPoint(x: 2.91, y: 0))
            bezierPath.addLine(to: CGPoint(x: 0, y: 2.88))
            bezierPath.addLine(to: CGPoint(x: 10.23, y: 13))
            bezierPath.addLine(to: CGPoint(x: 0, y: 23.12))
            bezierPath.addLine(to: CGPoint(x: 2.91, y: 26))
            bezierPath.addLine(to: CGPoint(x: 16, y: 13.05))
            bezierPath.addLine(to: CGPoint(x: 15.95, y: 13))
            bezierPath.close()
            bezierPath.usesEvenOddFillRule = true
            fillColor12.setFill()
            bezierPath.fill()
        }
    }
    
}
