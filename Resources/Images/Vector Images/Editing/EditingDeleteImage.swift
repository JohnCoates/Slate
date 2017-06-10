//
//  EditingDeleteImage.swift
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// codebeat:disable[ABC,ARITY,CYCLO,LOC,TOTAL_COMPLEXITY,TOTAL_LOC,TOO_MANY_IVARS]

import Foundation

extension DrawProxyDSL {
    class EditingDeleteImage: VectorImageAsset {
        
        let asset = EditingImage.delete
        lazy var name: String = self.asset.rawValue
        lazy var section: String = self.asset.section
        
        let width: CGFloat = 33
        let height: CGFloat = 7
        
        func simulateDraw() {
            let iconPath = UIBezierPath()
            iconPath.move(to: CGPoint(x: 29.7, y: 7))
            iconPath.addLine(to: CGPoint(x: 3.3, y: 7))
            iconPath.addCurve(to: CGPoint(x: 0, y: 3.5), controlPoint1: CGPoint(x: 1.48, y: 7), controlPoint2: CGPoint(x: 0, y: 5.43))
            iconPath.addCurve(to: CGPoint(x: 3.3, y: 0), controlPoint1: CGPoint(x: 0, y: 1.57), controlPoint2: CGPoint(x: 1.48, y: 0))
            iconPath.addLine(to: CGPoint(x: 29.7, y: 0))
            iconPath.addCurve(to: CGPoint(x: 33, y: 3.5), controlPoint1: CGPoint(x: 31.52, y: 0), controlPoint2: CGPoint(x: 33, y: 1.57))
            iconPath.addCurve(to: CGPoint(x: 29.7, y: 7), controlPoint1: CGPoint(x: 33, y: 5.43), controlPoint2: CGPoint(x: 31.52, y: 7))
            iconPath.close()
        }
    }
}
