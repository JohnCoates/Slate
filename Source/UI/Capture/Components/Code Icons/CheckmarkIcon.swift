//
//  CheckmarkIcon.swift
//  Slate
//
//  Created by John Coates on 5/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

struct CheckmarkIcon: PathIcon {
    
    let canvasWidth: CGFloat = 100
    let canvasHeight: CGFloat = 70
    let width: CGFloat = 37
    let height: CGFloat = 32.06
    
    lazy var path: CGPath = {
        let iconPath = UIBezierPath()
        iconPath.move(to: CGPoint(x: 92.22, y: 1.64))
        iconPath.addLine(to: CGPoint(x: 33.3, y: 75.61))
        iconPath.addLine(to: CGPoint(x: 7.76, y: 43.54))
        iconPath.addCurve(to: CGPoint(x: 1.63, y: 42.86), controlPoint1: CGPoint(x: 6.26, y: 41.66), controlPoint2: CGPoint(x: 3.52, y: 41.35))
        iconPath.addCurve(to: CGPoint(x: 0.95, y: 49.02), controlPoint1: CGPoint(x: -0.24, y: 44.37), controlPoint2: CGPoint(x: -0.55, y: 47.12))
        iconPath.addLine(to: CGPoint(x: 29.89, y: 85.35))
        iconPath.addCurve(to: CGPoint(x: 33.3, y: 87), controlPoint1: CGPoint(x: 30.72, y: 86.39), controlPoint2: CGPoint(x: 31.98, y: 87))
        iconPath.addCurve(to: CGPoint(x: 36.71, y: 85.35), controlPoint1: CGPoint(x: 34.63, y: 87), controlPoint2: CGPoint(x: 35.88, y: 86.4))
        iconPath.addLine(to: CGPoint(x: 99.04, y: 7.11))
        iconPath.addCurve(to: CGPoint(x: 98.36, y: 0.95), controlPoint1: CGPoint(x: 100.54, y: 5.22), controlPoint2: CGPoint(x: 100.25, y: 2.47))
        iconPath.addCurve(to: CGPoint(x: 92.22, y: 1.64), controlPoint1: CGPoint(x: 96.48, y: -0.55), controlPoint2: CGPoint(x: 93.74, y: -0.25))
        iconPath.addLine(to: CGPoint(x: 92.22, y: 1.64))
        iconPath.close()
        
        return iconPath.cgPath
    }()
}
