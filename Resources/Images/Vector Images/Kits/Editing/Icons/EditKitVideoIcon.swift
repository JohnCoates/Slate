//
//  EditKitVideoIcon.swift
//  Slate
//
//  Created by John Coates on 6/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension DrawProxyDSL {
    class EditKitVideoIcon: VectorImageAsset {
        
        let asset = KitEditImage.video
        lazy var name: String = self.asset.rawValue
        lazy var section: String = self.asset.section
        
        let width: CGFloat = 40
        let height: CGFloat = 35
        
        func simulateDraw() {
            //// Color Declarations
            let fillColor12 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
            
            //// Bezier Drawing
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 0, y: 0))
            bezierPath.addLine(to: CGPoint(x: 40, y: 0))
            bezierPath.addLine(to: CGPoint(x: 40, y: 35))
            bezierPath.addLine(to: CGPoint(x: 0, y: 35))
            bezierPath.addLine(to: CGPoint(x: 0, y: 0))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 1.67, y: 1.67))
            bezierPath.addLine(to: CGPoint(x: 1.67, y: 8.33))
            bezierPath.addLine(to: CGPoint(x: 8.33, y: 8.33))
            bezierPath.addLine(to: CGPoint(x: 8.33, y: 1.67))
            bezierPath.addLine(to: CGPoint(x: 1.67, y: 1.67))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 1.67, y: 10))
            bezierPath.addLine(to: CGPoint(x: 1.67, y: 16.67))
            bezierPath.addLine(to: CGPoint(x: 8.33, y: 16.67))
            bezierPath.addLine(to: CGPoint(x: 8.33, y: 10))
            bezierPath.addLine(to: CGPoint(x: 1.67, y: 10))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 1.67, y: 18.33))
            bezierPath.addLine(to: CGPoint(x: 1.67, y: 25))
            bezierPath.addLine(to: CGPoint(x: 8.33, y: 25))
            bezierPath.addLine(to: CGPoint(x: 8.33, y: 18.33))
            bezierPath.addLine(to: CGPoint(x: 1.67, y: 18.33))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 1.67, y: 26.67))
            bezierPath.addLine(to: CGPoint(x: 1.67, y: 33.33))
            bezierPath.addLine(to: CGPoint(x: 8.33, y: 33.33))
            bezierPath.addLine(to: CGPoint(x: 8.33, y: 26.67))
            bezierPath.addLine(to: CGPoint(x: 1.67, y: 26.67))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 31.67, y: 26.67))
            bezierPath.addLine(to: CGPoint(x: 31.67, y: 33.33))
            bezierPath.addLine(to: CGPoint(x: 38.33, y: 33.33))
            bezierPath.addLine(to: CGPoint(x: 38.33, y: 26.67))
            bezierPath.addLine(to: CGPoint(x: 31.67, y: 26.67))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 31.67, y: 18.33))
            bezierPath.addLine(to: CGPoint(x: 31.67, y: 25))
            bezierPath.addLine(to: CGPoint(x: 38.33, y: 25))
            bezierPath.addLine(to: CGPoint(x: 38.33, y: 18.33))
            bezierPath.addLine(to: CGPoint(x: 31.67, y: 18.33))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 31.67, y: 10))
            bezierPath.addLine(to: CGPoint(x: 31.67, y: 16.67))
            bezierPath.addLine(to: CGPoint(x: 38.33, y: 16.67))
            bezierPath.addLine(to: CGPoint(x: 38.33, y: 10))
            bezierPath.addLine(to: CGPoint(x: 31.67, y: 10))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 31.67, y: 1.67))
            bezierPath.addLine(to: CGPoint(x: 31.67, y: 8.33))
            bezierPath.addLine(to: CGPoint(x: 38.33, y: 8.33))
            bezierPath.addLine(to: CGPoint(x: 38.33, y: 1.67))
            bezierPath.addLine(to: CGPoint(x: 31.67, y: 1.67))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 10, y: 1.67))
            bezierPath.addLine(to: CGPoint(x: 10, y: 16.67))
            bezierPath.addLine(to: CGPoint(x: 30, y: 16.67))
            bezierPath.addLine(to: CGPoint(x: 30, y: 1.67))
            bezierPath.addLine(to: CGPoint(x: 10, y: 1.67))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 10, y: 18.33))
            bezierPath.addLine(to: CGPoint(x: 10, y: 33.33))
            bezierPath.addLine(to: CGPoint(x: 30, y: 33.33))
            bezierPath.addLine(to: CGPoint(x: 30, y: 18.33))
            bezierPath.addLine(to: CGPoint(x: 10, y: 18.33))
            bezierPath.close()
            bezierPath.usesEvenOddFillRule = true
            fillColor12.setFill()
            bezierPath.fill()
        }
    }
    
}
