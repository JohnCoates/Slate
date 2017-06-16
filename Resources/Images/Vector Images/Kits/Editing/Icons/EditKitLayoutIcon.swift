//
//  EditKitLayoutIcon.swift
//  Slate
//
//  Created by John Coates on 6/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension DrawProxyDSL {
    class EditKitLayoutIcon: VectorImageAsset {
        
        let asset = KitEditImage.layout
        lazy var name: String = self.asset.rawValue
        lazy var section: String = self.asset.section
        
        let width: CGFloat = 40
        let height: CGFloat = 40
        
        func simulateDraw() {
            //// Color Declarations
            let fillColor12 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
            
            //// Bezier Drawing
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 36.16, y: 31.56))
            bezierPath.addLine(to: CGPoint(x: 36.16, y: 8.44))
            bezierPath.addCurve(to: CGPoint(x: 40, y: 4.24), controlPoint1: CGPoint(x: 38.31, y: 8.23), controlPoint2: CGPoint(x: 40, y: 6.44))
            bezierPath.addCurve(to: CGPoint(x: 35.76, y: 0), controlPoint1: CGPoint(x: 40, y: 1.9), controlPoint2: CGPoint(x: 38.1, y: 0))
            bezierPath.addCurve(to: CGPoint(x: 31.56, y: 3.83), controlPoint1: CGPoint(x: 33.56, y: 0), controlPoint2: CGPoint(x: 31.77, y: 1.68))
            bezierPath.addLine(to: CGPoint(x: 8.44, y: 3.83))
            bezierPath.addCurve(to: CGPoint(x: 4.24, y: 0), controlPoint1: CGPoint(x: 8.23, y: 1.68), controlPoint2: CGPoint(x: 6.44, y: 0))
            bezierPath.addCurve(to: CGPoint(x: 0, y: 4.24), controlPoint1: CGPoint(x: 1.9, y: 0), controlPoint2: CGPoint(x: 0, y: 1.9))
            bezierPath.addCurve(to: CGPoint(x: 3.84, y: 8.44), controlPoint1: CGPoint(x: 0, y: 6.44), controlPoint2: CGPoint(x: 1.69, y: 8.23))
            bezierPath.addLine(to: CGPoint(x: 3.84, y: 31.56))
            bezierPath.addCurve(to: CGPoint(x: 0, y: 35.76), controlPoint1: CGPoint(x: 1.69, y: 31.77), controlPoint2: CGPoint(x: 0, y: 33.56))
            bezierPath.addCurve(to: CGPoint(x: 4.24, y: 40), controlPoint1: CGPoint(x: 0, y: 38.1), controlPoint2: CGPoint(x: 1.9, y: 40))
            bezierPath.addCurve(to: CGPoint(x: 8.44, y: 36.15), controlPoint1: CGPoint(x: 6.45, y: 40), controlPoint2: CGPoint(x: 8.24, y: 38.3))
            bezierPath.addLine(to: CGPoint(x: 31.56, y: 36.15))
            bezierPath.addCurve(to: CGPoint(x: 35.76, y: 40), controlPoint1: CGPoint(x: 31.76, y: 38.3), controlPoint2: CGPoint(x: 33.55, y: 40))
            bezierPath.addCurve(to: CGPoint(x: 40, y: 35.76), controlPoint1: CGPoint(x: 38.1, y: 40), controlPoint2: CGPoint(x: 40, y: 38.09))
            bezierPath.addCurve(to: CGPoint(x: 36.16, y: 31.56), controlPoint1: CGPoint(x: 40, y: 33.56), controlPoint2: CGPoint(x: 38.31, y: 31.77))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 31.77, y: 34.36))
            bezierPath.addLine(to: CGPoint(x: 8.23, y: 34.36))
            bezierPath.addCurve(to: CGPoint(x: 5.63, y: 31.77), controlPoint1: CGPoint(x: 7.8, y: 33.14), controlPoint2: CGPoint(x: 6.85, y: 32.19))
            bezierPath.addLine(to: CGPoint(x: 5.63, y: 8.23))
            bezierPath.addCurve(to: CGPoint(x: 8.23, y: 5.62), controlPoint1: CGPoint(x: 6.85, y: 7.8), controlPoint2: CGPoint(x: 7.81, y: 6.84))
            bezierPath.addLine(to: CGPoint(x: 31.77, y: 5.62))
            bezierPath.addCurve(to: CGPoint(x: 34.37, y: 8.23), controlPoint1: CGPoint(x: 32.19, y: 6.84), controlPoint2: CGPoint(x: 33.15, y: 7.8))
            bezierPath.addLine(to: CGPoint(x: 34.37, y: 31.77))
            bezierPath.addCurve(to: CGPoint(x: 31.77, y: 34.36), controlPoint1: CGPoint(x: 33.15, y: 32.19), controlPoint2: CGPoint(x: 32.2, y: 33.14))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 35.76, y: 1.8))
            bezierPath.addCurve(to: CGPoint(x: 38.2, y: 4.24), controlPoint1: CGPoint(x: 37.1, y: 1.8), controlPoint2: CGPoint(x: 38.2, y: 2.89))
            bezierPath.addCurve(to: CGPoint(x: 35.76, y: 6.69), controlPoint1: CGPoint(x: 38.2, y: 5.59), controlPoint2: CGPoint(x: 37.1, y: 6.69))
            bezierPath.addCurve(to: CGPoint(x: 33.31, y: 4.24), controlPoint1: CGPoint(x: 34.41, y: 6.69), controlPoint2: CGPoint(x: 33.31, y: 5.59))
            bezierPath.addCurve(to: CGPoint(x: 35.76, y: 1.8), controlPoint1: CGPoint(x: 33.31, y: 2.89), controlPoint2: CGPoint(x: 34.41, y: 1.8))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 1.8, y: 4.24))
            bezierPath.addCurve(to: CGPoint(x: 4.24, y: 1.8), controlPoint1: CGPoint(x: 1.8, y: 2.89), controlPoint2: CGPoint(x: 2.89, y: 1.8))
            bezierPath.addCurve(to: CGPoint(x: 6.69, y: 4.24), controlPoint1: CGPoint(x: 5.59, y: 1.8), controlPoint2: CGPoint(x: 6.69, y: 2.89))
            bezierPath.addCurve(to: CGPoint(x: 4.24, y: 6.69), controlPoint1: CGPoint(x: 6.69, y: 5.59), controlPoint2: CGPoint(x: 5.59, y: 6.69))
            bezierPath.addCurve(to: CGPoint(x: 1.8, y: 4.24), controlPoint1: CGPoint(x: 2.89, y: 6.69), controlPoint2: CGPoint(x: 1.8, y: 5.59))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 4.24, y: 38.2))
            bezierPath.addCurve(to: CGPoint(x: 1.8, y: 35.76), controlPoint1: CGPoint(x: 2.89, y: 38.2), controlPoint2: CGPoint(x: 1.8, y: 37.11))
            bezierPath.addCurve(to: CGPoint(x: 4.24, y: 33.31), controlPoint1: CGPoint(x: 1.8, y: 34.41), controlPoint2: CGPoint(x: 2.89, y: 33.31))
            bezierPath.addCurve(to: CGPoint(x: 6.69, y: 35.76), controlPoint1: CGPoint(x: 5.59, y: 33.31), controlPoint2: CGPoint(x: 6.69, y: 34.41))
            bezierPath.addCurve(to: CGPoint(x: 4.24, y: 38.2), controlPoint1: CGPoint(x: 6.69, y: 37.11), controlPoint2: CGPoint(x: 5.59, y: 38.2))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 35.76, y: 38.2))
            bezierPath.addCurve(to: CGPoint(x: 33.31, y: 35.76), controlPoint1: CGPoint(x: 34.41, y: 38.2), controlPoint2: CGPoint(x: 33.31, y: 37.11))
            bezierPath.addCurve(to: CGPoint(x: 35.76, y: 33.31), controlPoint1: CGPoint(x: 33.31, y: 34.41), controlPoint2: CGPoint(x: 34.41, y: 33.31))
            bezierPath.addCurve(to: CGPoint(x: 38.2, y: 35.76), controlPoint1: CGPoint(x: 37.1, y: 33.31), controlPoint2: CGPoint(x: 38.2, y: 34.41))
            bezierPath.addCurve(to: CGPoint(x: 35.76, y: 38.2), controlPoint1: CGPoint(x: 38.2, y: 37.11), controlPoint2: CGPoint(x: 37.1, y: 38.2))
            bezierPath.close()
            fillColor12.setFill()
            bezierPath.fill()
        }
    }
    
}
