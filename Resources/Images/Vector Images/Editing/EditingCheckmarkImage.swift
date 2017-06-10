//
//  EditingCheckmarkImage.swift
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// codebeat:disable[ABC,ARITY,CYCLO,LOC,TOTAL_COMPLEXITY,TOTAL_LOC,TOO_MANY_IVARS]

import Foundation

extension DrawProxyDSL {
    class EditingCheckmarkImage: VectorImageAsset {
        
        let asset = EditingImage.checkmark
        lazy var name: String = self.asset.rawValue
        lazy var section: String = self.asset.section
        
        let width: CGFloat = 37
        let height: CGFloat = 32.06
        
        func simulateDraw() {
            let iconPath = UIBezierPath()
            iconPath.move(to: CGPoint(x: 34.12, y: 0.61))
            iconPath.addLine(to: CGPoint(x: 12.32, y: 27.86))
            iconPath.addLine(to: CGPoint(x: 2.87, y: 16.05))
            iconPath.addCurve(to: CGPoint(x: 0.6, y: 15.79), controlPoint1: CGPoint(x: 2.31, y: 15.35), controlPoint2: CGPoint(x: 1.3, y: 15.24))
            iconPath.addCurve(to: CGPoint(x: 0.35, y: 18.06), controlPoint1: CGPoint(x: -0.09, y: 16.35), controlPoint2: CGPoint(x: -0.2, y: 17.37))
            iconPath.addLine(to: CGPoint(x: 11.06, y: 31.45))
            iconPath.addCurve(to: CGPoint(x: 12.32, y: 32.06), controlPoint1: CGPoint(x: 11.37, y: 31.83), controlPoint2: CGPoint(x: 11.83, y: 32.06))
            iconPath.addCurve(to: CGPoint(x: 13.58, y: 31.45), controlPoint1: CGPoint(x: 12.81, y: 32.06), controlPoint2: CGPoint(x: 13.27, y: 31.84))
            iconPath.addLine(to: CGPoint(x: 36.65, y: 2.62))
            iconPath.addCurve(to: CGPoint(x: 36.39, y: 0.35), controlPoint1: CGPoint(x: 37.2, y: 1.92), controlPoint2: CGPoint(x: 37.09, y: 0.91))
            iconPath.addCurve(to: CGPoint(x: 34.12, y: 0.61), controlPoint1: CGPoint(x: 35.7, y: -0.2), controlPoint2: CGPoint(x: 34.68, y: -0.09))
            iconPath.addLine(to: CGPoint(x: 34.12, y: 0.61))
            iconPath.close()
        }
    }
}
