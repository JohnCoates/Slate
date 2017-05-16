//
//  DeleteLineIcon.swift
//  Slate
//
//  Created by John Coates on 5/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

struct DeleteLineIcon: PathIcon {
    let width: CGFloat = 33
    let height: CGFloat = 7
    
    let path: CGPath = {
        let iconPath = UIBezierPath()
        iconPath.move(to: CGPoint(x: 29.7, y: 7))
        iconPath.addLine(to: CGPoint(x: 3.3, y: 7))
        iconPath.addCurve(to: CGPoint(x: 0, y: 3.5), controlPoint1: CGPoint(x: 1.48, y: 7), controlPoint2: CGPoint(x: 0, y: 5.43))
        iconPath.addCurve(to: CGPoint(x: 3.3, y: 0), controlPoint1: CGPoint(x: 0, y: 1.57), controlPoint2: CGPoint(x: 1.48, y: 0))
        iconPath.addLine(to: CGPoint(x: 29.7, y: 0))
        iconPath.addCurve(to: CGPoint(x: 33, y: 3.5), controlPoint1: CGPoint(x: 31.52, y: 0), controlPoint2: CGPoint(x: 33, y: 1.57))
        iconPath.addCurve(to: CGPoint(x: 29.7, y: 7), controlPoint1: CGPoint(x: 33, y: 5.43), controlPoint2: CGPoint(x: 31.52, y: 7))
        iconPath.close()
        return iconPath.cgPath
    }()
}
