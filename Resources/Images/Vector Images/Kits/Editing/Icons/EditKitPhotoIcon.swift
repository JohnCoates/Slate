//
//  EditKitPhotoIcon.swift
//  Slate
//
//  Created by John Coates on 6/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension DrawProxyDSL {
    class EditKitPhotoIcon: VectorImageAsset {
        
        let asset = KitEditImage.photo
        lazy var name: String = self.asset.rawValue
        lazy var section: String = self.asset.section
        
        let width: CGFloat = 40
        let height: CGFloat = 40
        
        func simulateDraw() {
            //// Color Declarations
            let fillColor12 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
            let strokeColor3 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
            
            //// Group 2
            //// Bezier Drawing
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 38.75, y: 38.61))
            bezierPath.addLine(to: CGPoint(x: 29.1, y: 38.61))
            bezierPath.addLine(to: CGPoint(x: 28.48, y: 38.61))
            bezierPath.addLine(to: CGPoint(x: 28.48, y: 39.85))
            bezierPath.addLine(to: CGPoint(x: 29.1, y: 39.85))
            bezierPath.addLine(to: CGPoint(x: 39.06, y: 39.85))
            bezierPath.addLine(to: CGPoint(x: 40, y: 39.85))
            bezierPath.addLine(to: CGPoint(x: 40, y: 39.23))
            bezierPath.addLine(to: CGPoint(x: 40, y: 29.19))
            bezierPath.addLine(to: CGPoint(x: 40, y: 28.57))
            bezierPath.addLine(to: CGPoint(x: 38.75, y: 28.57))
            bezierPath.addLine(to: CGPoint(x: 38.75, y: 29.19))
            bezierPath.addLine(to: CGPoint(x: 38.75, y: 38.61))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 1.24, y: 0.3))
            bezierPath.addLine(to: CGPoint(x: 1.24, y: 0.26))
            bezierPath.addLine(to: CGPoint(x: 0, y: 0.26))
            bezierPath.addLine(to: CGPoint(x: 0, y: 0.89))
            bezierPath.addLine(to: CGPoint(x: 0, y: 11.16))
            bezierPath.addLine(to: CGPoint(x: 0, y: 11.78))
            bezierPath.addLine(to: CGPoint(x: 1.24, y: 11.78))
            bezierPath.addLine(to: CGPoint(x: 1.24, y: 11.16))
            bezierPath.addLine(to: CGPoint(x: 1.24, y: 1.55))
            bezierPath.addLine(to: CGPoint(x: 10.7, y: 1.55))
            bezierPath.addLine(to: CGPoint(x: 11.31, y: 1.55))
            bezierPath.addLine(to: CGPoint(x: 11.31, y: 0.3))
            bezierPath.addLine(to: CGPoint(x: 10.7, y: 0.3))
            bezierPath.addLine(to: CGPoint(x: 1.24, y: 0.3))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 1.24, y: 38.76))
            bezierPath.addLine(to: CGPoint(x: 1.24, y: 29.15))
            bezierPath.addLine(to: CGPoint(x: 1.24, y: 28.53))
            bezierPath.addLine(to: CGPoint(x: 0, y: 28.53))
            bezierPath.addLine(to: CGPoint(x: 0, y: 29.15))
            bezierPath.addLine(to: CGPoint(x: 0, y: 39.42))
            bezierPath.addLine(to: CGPoint(x: 0, y: 40.04))
            bezierPath.addLine(to: CGPoint(x: 1.24, y: 40.04))
            bezierPath.addLine(to: CGPoint(x: 1.24, y: 40))
            bezierPath.addLine(to: CGPoint(x: 10.7, y: 40))
            bezierPath.addLine(to: CGPoint(x: 11.31, y: 40))
            bezierPath.addLine(to: CGPoint(x: 11.31, y: 38.76))
            bezierPath.addLine(to: CGPoint(x: 10.7, y: 38.76))
            bezierPath.addLine(to: CGPoint(x: 1.24, y: 38.76))
            bezierPath.close()
            bezierPath.move(to: CGPoint(x: 40, y: 1.08))
            bezierPath.addLine(to: CGPoint(x: 40, y: 0))
            bezierPath.addLine(to: CGPoint(x: 39.37, y: 0))
            bezierPath.addLine(to: CGPoint(x: 29.1, y: 0))
            bezierPath.addLine(to: CGPoint(x: 28.48, y: 0))
            bezierPath.addLine(to: CGPoint(x: 28.48, y: 1.24))
            bezierPath.addLine(to: CGPoint(x: 29.1, y: 1.24))
            bezierPath.addLine(to: CGPoint(x: 38.75, y: 1.24))
            bezierPath.addLine(to: CGPoint(x: 38.75, y: 10.97))
            bezierPath.addLine(to: CGPoint(x: 38.75, y: 11.58))
            bezierPath.addLine(to: CGPoint(x: 40, y: 11.58))
            bezierPath.addLine(to: CGPoint(x: 40, y: 10.97))
            bezierPath.addLine(to: CGPoint(x: 40, y: 1.08))
            bezierPath.close()
            bezierPath.usesEvenOddFillRule = true
            fillColor12.setFill()
            bezierPath.fill()
            
            
            //// Bezier 2 Drawing
            let bezier2Path = UIBezierPath()
            bezier2Path.move(to: CGPoint(x: 38.75, y: 38.61))
            bezier2Path.addLine(to: CGPoint(x: 29.1, y: 38.61))
            bezier2Path.addLine(to: CGPoint(x: 28.48, y: 38.61))
            bezier2Path.addLine(to: CGPoint(x: 28.48, y: 39.85))
            bezier2Path.addLine(to: CGPoint(x: 29.1, y: 39.85))
            bezier2Path.addLine(to: CGPoint(x: 39.06, y: 39.85))
            bezier2Path.addLine(to: CGPoint(x: 40, y: 39.85))
            bezier2Path.addLine(to: CGPoint(x: 40, y: 39.23))
            bezier2Path.addLine(to: CGPoint(x: 40, y: 29.19))
            bezier2Path.addLine(to: CGPoint(x: 40, y: 28.57))
            bezier2Path.addLine(to: CGPoint(x: 38.75, y: 28.57))
            bezier2Path.addLine(to: CGPoint(x: 38.75, y: 29.19))
            bezier2Path.addLine(to: CGPoint(x: 38.75, y: 38.61))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 1.24, y: 0.3))
            bezier2Path.addLine(to: CGPoint(x: 1.24, y: 0.26))
            bezier2Path.addLine(to: CGPoint(x: 0, y: 0.26))
            bezier2Path.addLine(to: CGPoint(x: 0, y: 0.89))
            bezier2Path.addLine(to: CGPoint(x: 0, y: 11.16))
            bezier2Path.addLine(to: CGPoint(x: 0, y: 11.78))
            bezier2Path.addLine(to: CGPoint(x: 1.24, y: 11.78))
            bezier2Path.addLine(to: CGPoint(x: 1.24, y: 11.16))
            bezier2Path.addLine(to: CGPoint(x: 1.24, y: 1.55))
            bezier2Path.addLine(to: CGPoint(x: 10.7, y: 1.55))
            bezier2Path.addLine(to: CGPoint(x: 11.31, y: 1.55))
            bezier2Path.addLine(to: CGPoint(x: 11.31, y: 0.3))
            bezier2Path.addLine(to: CGPoint(x: 10.7, y: 0.3))
            bezier2Path.addLine(to: CGPoint(x: 1.24, y: 0.3))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 1.24, y: 38.76))
            bezier2Path.addLine(to: CGPoint(x: 1.24, y: 29.15))
            bezier2Path.addLine(to: CGPoint(x: 1.24, y: 28.53))
            bezier2Path.addLine(to: CGPoint(x: 0, y: 28.53))
            bezier2Path.addLine(to: CGPoint(x: 0, y: 29.15))
            bezier2Path.addLine(to: CGPoint(x: 0, y: 39.42))
            bezier2Path.addLine(to: CGPoint(x: 0, y: 40.04))
            bezier2Path.addLine(to: CGPoint(x: 1.24, y: 40.04))
            bezier2Path.addLine(to: CGPoint(x: 1.24, y: 40))
            bezier2Path.addLine(to: CGPoint(x: 10.7, y: 40))
            bezier2Path.addLine(to: CGPoint(x: 11.31, y: 40))
            bezier2Path.addLine(to: CGPoint(x: 11.31, y: 38.76))
            bezier2Path.addLine(to: CGPoint(x: 10.7, y: 38.76))
            bezier2Path.addLine(to: CGPoint(x: 1.24, y: 38.76))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 40, y: 1.08))
            bezier2Path.addLine(to: CGPoint(x: 40, y: 0))
            bezier2Path.addLine(to: CGPoint(x: 39.37, y: 0))
            bezier2Path.addLine(to: CGPoint(x: 29.1, y: 0))
            bezier2Path.addLine(to: CGPoint(x: 28.48, y: 0))
            bezier2Path.addLine(to: CGPoint(x: 28.48, y: 1.24))
            bezier2Path.addLine(to: CGPoint(x: 29.1, y: 1.24))
            bezier2Path.addLine(to: CGPoint(x: 38.75, y: 1.24))
            bezier2Path.addLine(to: CGPoint(x: 38.75, y: 10.97))
            bezier2Path.addLine(to: CGPoint(x: 38.75, y: 11.58))
            bezier2Path.addLine(to: CGPoint(x: 40, y: 11.58))
            bezier2Path.addLine(to: CGPoint(x: 40, y: 10.97))
            bezier2Path.addLine(to: CGPoint(x: 40, y: 1.08))
            bezier2Path.close()
            strokeColor3.setStroke()
            bezier2Path.lineWidth = 2
            bezier2Path.lineCapStyle = .square
            bezier2Path.stroke()
        }
    }
    
}
