//
//  InteractivityIndicatorIcon.swift
//  Slate
//
//  Created by John Coates on 5/21/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable line_length
// codebeat:disable[ABC,ARITY,CYCLO,LOC,TOTAL_COMPLEXITY,TOTAL_LOC,TOO_MANY_IVARS]

import UIKit

struct InteractivityIndicatorIcon: CanvasIcon {
    let width: CGFloat = 21
    let height: CGFloat = 7
    
    func drawing() {
        let fillColor12 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        let iconPath = UIBezierPath()
        iconPath.move(to: CGPoint(x: 10.5, y: 7))
        iconPath.addCurve(to: CGPoint(x: 10.13, y: 6.9), controlPoint1: CGPoint(x: 10.37, y: 7), controlPoint2: CGPoint(x: 10.25, y: 6.97))
        iconPath.addLine(to: CGPoint(x: 0.38, y: 1.4))
        iconPath.addCurve(to: CGPoint(x: 0.1, y: 0.38), controlPoint1: CGPoint(x: 0.02, y: 1.2), controlPoint2: CGPoint(x: -0.11, y: 0.74))
        iconPath.addCurve(to: CGPoint(x: 1.12, y: 0.1), controlPoint1: CGPoint(x: 0.3, y: 0.02), controlPoint2: CGPoint(x: 0.76, y: -0.1))
        iconPath.addLine(to: CGPoint(x: 10.5, y: 5.39))
        iconPath.addLine(to: CGPoint(x: 19.88, y: 0.1))
        iconPath.addCurve(to: CGPoint(x: 20.9, y: 0.38), controlPoint1: CGPoint(x: 20.24, y: -0.11), controlPoint2: CGPoint(x: 20.7, y: 0.02))
        iconPath.addCurve(to: CGPoint(x: 20.62, y: 1.4), controlPoint1: CGPoint(x: 21.11, y: 0.74), controlPoint2: CGPoint(x: 20.98, y: 1.2))
        iconPath.addLine(to: CGPoint(x: 10.87, y: 6.9))
        iconPath.addCurve(to: CGPoint(x: 10.5, y: 7), controlPoint1: CGPoint(x: 10.75, y: 6.97), controlPoint2: CGPoint(x: 10.63, y: 7))
        iconPath.addLine(to: CGPoint(x: 10.5, y: 7))
        iconPath.close()
        iconPath.usesEvenOddFillRule = true
        fillColor12.setFill()
        iconPath.fill()
    }
}
