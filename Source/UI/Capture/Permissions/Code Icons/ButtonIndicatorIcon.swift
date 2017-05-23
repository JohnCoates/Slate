//
//  ButtonIndicatorIcon.swift
//  Slate
//
//  Created by John Coates on 5/16/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

struct ButtonIndicatorIcon: CanvasIcon {
    let width: CGFloat = 20
    let height: CGFloat = 15
    let color: UIColor = UIColor(red: 0.000, green: 0.518, blue: 1.000, alpha: 1.000)
    
    func drawing() {
        let iconPath = UIBezierPath()
        iconPath.move(to: CGPoint(x: 0, y: 10.5))
        iconPath.addLine(to: CGPoint(x: 10.27, y: 0))
        iconPath.addLine(to: CGPoint(x: 20.5, y: 10.48))
        color.setStroke()
        iconPath.lineWidth = 1
        iconPath.lineCapStyle = .round
        iconPath.lineJoinStyle = .round
        iconPath.stroke()
    }
}

