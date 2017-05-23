//
//  XIcon.swift
//  Slate
//
//  Created by John Coates on 5/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

struct XIcon: PathIcon {
    let width: CGFloat = 38
    let height: CGFloat = 38
    
    let path: CGPath = {
        let iconPath = UIBezierPath()
        iconPath.move(to: CGPoint(x: 37.45, y: 0.54))
        iconPath.addCurve(to: CGPoint(x: 34.83, y: 0.54), controlPoint1: CGPoint(x: 36.73, y: -0.18), controlPoint2: CGPoint(x: 35.55, y: -0.18))
        iconPath.addLine(to: CGPoint(x: 19, y: 16.38))
        iconPath.addLine(to: CGPoint(x: 3.17, y: 0.54))
        iconPath.addCurve(to: CGPoint(x: 0.54, y: 0.54), controlPoint1: CGPoint(x: 2.44, y: -0.18), controlPoint2: CGPoint(x: 1.27, y: -0.18))
        iconPath.addCurve(to: CGPoint(x: 0.54, y: 3.17), controlPoint1: CGPoint(x: -0.18, y: 1.27), controlPoint2: CGPoint(x: -0.18, y: 2.44))
        iconPath.addLine(to: CGPoint(x: 16.37, y: 19))
        iconPath.addLine(to: CGPoint(x: 0.54, y: 34.83))
        iconPath.addCurve(to: CGPoint(x: 0.54, y: 37.46), controlPoint1: CGPoint(x: -0.18, y: 35.56), controlPoint2: CGPoint(x: -0.18, y: 36.73))
        iconPath.addCurve(to: CGPoint(x: 1.86, y: 38), controlPoint1: CGPoint(x: 0.91, y: 37.82), controlPoint2: CGPoint(x: 1.38, y: 38))
        iconPath.addCurve(to: CGPoint(x: 3.17, y: 37.46), controlPoint1: CGPoint(x: 2.33, y: 38), controlPoint2: CGPoint(x: 2.81, y: 37.82))
        iconPath.addLine(to: CGPoint(x: 19, y: 21.62))
        iconPath.addLine(to: CGPoint(x: 34.83, y: 37.46))
        iconPath.addCurve(to: CGPoint(x: 36.14, y: 38), controlPoint1: CGPoint(x: 35.19, y: 37.82), controlPoint2: CGPoint(x: 35.67, y: 38))
        iconPath.addCurve(to: CGPoint(x: 37.46, y: 37.46), controlPoint1: CGPoint(x: 36.62, y: 38), controlPoint2: CGPoint(x: 37.09, y: 37.82))
        iconPath.addCurve(to: CGPoint(x: 37.46, y: 34.83), controlPoint1: CGPoint(x: 38.18, y: 36.73), controlPoint2: CGPoint(x: 38.18, y: 35.56))
        iconPath.addLine(to: CGPoint(x: 21.63, y: 19))
        iconPath.addLine(to: CGPoint(x: 37.46, y: 3.17))
        iconPath.addCurve(to: CGPoint(x: 37.45, y: 0.54), controlPoint1: CGPoint(x: 38.18, y: 2.44), controlPoint2: CGPoint(x: 38.18, y: 1.27))
        iconPath.addLine(to: CGPoint(x: 37.45, y: 0.54))
        iconPath.close()
        
        return iconPath.cgPath
    }()
}
