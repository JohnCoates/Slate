//
//  KitSettingsIcon.swift
//  Slate
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

struct KitSettingsIcon: CanvasIcon {
    let width: CGFloat = 44
    let height: CGFloat = 44
    
    func drawing() {
        //// Color Declarations
        let fillColor12 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        //// icon Drawing
        let iconPath = UIBezierPath()
        iconPath.move(to: CGPoint(x: 40.47, y: 40.63))
        iconPath.addCurve(to: CGPoint(x: 37.87, y: 40.63), controlPoint1: CGPoint(x: 39.75, y: 41.33), controlPoint2: CGPoint(x: 38.58, y: 41.33))
        iconPath.addCurve(to: CGPoint(x: 37.87, y: 38.01), controlPoint1: CGPoint(x: 37.15, y: 39.9), controlPoint2: CGPoint(x: 37.15, y: 38.73))
        iconPath.addCurve(to: CGPoint(x: 40.47, y: 38.01), controlPoint1: CGPoint(x: 38.58, y: 37.29), controlPoint2: CGPoint(x: 39.75, y: 37.29))
        iconPath.addCurve(to: CGPoint(x: 40.47, y: 40.63), controlPoint1: CGPoint(x: 41.19, y: 38.73), controlPoint2: CGPoint(x: 41.19, y: 39.9))
        iconPath.addLine(to: CGPoint(x: 40.47, y: 40.63))
        iconPath.close()
        iconPath.move(to: CGPoint(x: 19.16, y: 3.29))
        iconPath.addCurve(to: CGPoint(x: 11.38, y: 0), controlPoint1: CGPoint(x: 17.01, y: 1.13), controlPoint2: CGPoint(x: 14.2, y: 0.04))
        iconPath.addCurve(to: CGPoint(x: 10.4, y: 2.42), controlPoint1: CGPoint(x: 10.14, y: -0.02), controlPoint2: CGPoint(x: 9.51, y: 1.53))
        iconPath.addLine(to: CGPoint(x: 14.72, y: 6.76))
        iconPath.addCurve(to: CGPoint(x: 13.32, y: 11.45), controlPoint1: CGPoint(x: 15.74, y: 7.78), controlPoint2: CGPoint(x: 16.4, y: 8.33))
        iconPath.addLine(to: CGPoint(x: 11.93, y: 12.86))
        iconPath.addCurve(to: CGPoint(x: 6.8, y: 14.31), controlPoint1: CGPoint(x: 9.09, y: 15.72), controlPoint2: CGPoint(x: 7.82, y: 15.34))
        iconPath.addLine(to: CGPoint(x: 2.42, y: 9.88))
        iconPath.addCurve(to: CGPoint(x: 0, y: 10.88), controlPoint1: CGPoint(x: 1.53, y: 8.99), controlPoint2: CGPoint(x: -0.01, y: 9.62))
        iconPath.addCurve(to: CGPoint(x: 3.29, y: 18.86), controlPoint1: CGPoint(x: 0.01, y: 13.77), controlPoint2: CGPoint(x: 1.11, y: 16.66))
        iconPath.addCurve(to: CGPoint(x: 15.02, y: 21.53), controlPoint1: CGPoint(x: 6.46, y: 22.07), controlPoint2: CGPoint(x: 11.05, y: 22.95))
        iconPath.addCurve(to: CGPoint(x: 17, y: 22.06), controlPoint1: CGPoint(x: 15.71, y: 21.28), controlPoint2: CGPoint(x: 16.49, y: 21.52))
        iconPath.addLine(to: CGPoint(x: 36.03, y: 42.58))
        iconPath.addCurve(to: CGPoint(x: 42.59, y: 42.64), controlPoint1: CGPoint(x: 37.81, y: 44.45), controlPoint2: CGPoint(x: 40.77, y: 44.48))
        iconPath.addLine(to: CGPoint(x: 42.66, y: 42.58))
        iconPath.addCurve(to: CGPoint(x: 42.56, y: 35.99), controlPoint1: CGPoint(x: 44.49, y: 40.75), controlPoint2: CGPoint(x: 44.44, y: 37.77))
        iconPath.addLine(to: CGPoint(x: 22.35, y: 16.94))
        iconPath.addCurve(to: CGPoint(x: 21.81, y: 14.97), controlPoint1: CGPoint(x: 21.81, y: 16.44), controlPoint2: CGPoint(x: 21.57, y: 15.66))
        iconPath.addCurve(to: CGPoint(x: 19.16, y: 3.29), controlPoint1: CGPoint(x: 23.19, y: 11.02), controlPoint2: CGPoint(x: 22.31, y: 6.45))
        iconPath.addLine(to: CGPoint(x: 19.16, y: 3.29))
        iconPath.close()
        iconPath.usesEvenOddFillRule = true
        fillColor12.setFill()
        iconPath.fill()

    }
}

