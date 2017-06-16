//
//  EditKitPreviewIcon.swift
//  Slate
//
//  Created by John Coates on 6/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension DrawProxyDSL {
    class EditKitPreviewIcon: VectorImageAsset {
        
        let asset = KitEditImage.preview
        lazy var name: String = self.asset.rawValue
        lazy var section: String = self.asset.section
        
        let width: CGFloat = 40
        let height: CGFloat = 31
        
        func simulateDraw() {
            //// Color Declarations
            let strokeColor3 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
            
            //// Bezier Drawing
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 0, y: 0))
            bezierPath.addLine(to: CGPoint(x: 40, y: 0))
            bezierPath.addLine(to: CGPoint(x: 40, y: 31))
            bezierPath.addLine(to: CGPoint(x: 0, y: 31))
            bezierPath.addLine(to: CGPoint(x: 0, y: 0))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 6.09, y: 31))
            bezierPath.addLine(to: CGPoint(x: 33.91, y: 31))
            bezierPath.addLine(to: CGPoint(x: 26.96, y: 18.94))
            bezierPath.addLine(to: CGPoint(x: 22.87, y: 24.46))
            bezierPath.addLine(to: CGPoint(x: 16.35, y: 12.92))
            bezierPath.addLine(to: CGPoint(x: 6.09, y: 31))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 31.74, y: 12.92))
            bezierPath.addCurve(to: CGPoint(x: 34.78, y: 9.9), controlPoint1: CGPoint(x: 33.42, y: 12.92), controlPoint2: CGPoint(x: 34.78, y: 11.57))
            bezierPath.addCurve(to: CGPoint(x: 31.74, y: 6.89), controlPoint1: CGPoint(x: 34.78, y: 8.24), controlPoint2: CGPoint(x: 33.42, y: 6.89))
            bezierPath.addCurve(to: CGPoint(x: 28.7, y: 9.9), controlPoint1: CGPoint(x: 30.06, y: 6.89), controlPoint2: CGPoint(x: 28.7, y: 8.24))
            bezierPath.addCurve(to: CGPoint(x: 31.74, y: 12.92), controlPoint1: CGPoint(x: 28.7, y: 11.57), controlPoint2: CGPoint(x: 30.06, y: 12.92))
            bezierPath.close()
            strokeColor3.setStroke()
            bezierPath.lineWidth = 2
            bezierPath.stroke()
        }
    }
    
}
