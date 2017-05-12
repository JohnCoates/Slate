//
//  CircleEditControl.swift
//  Slate
//
//  Created by John Coates on 5/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Cartography

final class CircleEditControl: UIView {
    
    // MARK: - Init
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func initialSetup() {
        innerCircleSetup()
    }
    
    let innerCircle = CircleView()
    private func innerCircleSetup() {
        innerCircle.backgroundColor = UIColor(red:0.16, green:0.14, blue:0.17, alpha:1.00)
        addSubview(innerCircle)
        
        constrain(innerCircle) {
            let superview = $0.superview!
            $0.top == superview.top
            $0.left == superview.left
            $0.width == 60
            $0.height == $0.width
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressCircleSetup()
    }
    
    let progressCircle = CAShapeLayer()
    private func progressCircleSetup() {
        let strokeWidth: CGFloat = 4
        let center = CGPoint (x: innerCircle.frame.width / 2,
                              y: innerCircle.frame.height / 2)
        let circleRadius = (innerCircle.frame.width / 2) + (strokeWidth / 2)
        let percentage: Double = 0.2
        let endAngle: Double = 1 + (2 * percentage)
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: circleRadius,
                                      startAngle: CGFloat(Double.pi),
                                      endAngle: CGFloat(Double.pi * endAngle),
                                      clockwise: true)
        
        progressCircle.path = circlePath.cgPath
        progressCircle.strokeColor = UIColor(red:0.16, green:0.55, blue:0.79, alpha:1.00).cgColor
        progressCircle.fillColor = UIColor.clear.cgColor
        progressCircle.lineWidth = strokeWidth
        progressCircle.strokeStart = 0
        progressCircle.strokeEnd  = 1
        innerCircle.layer.addSublayer(progressCircle)
    }
}
