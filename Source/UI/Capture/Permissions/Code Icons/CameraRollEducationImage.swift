//
//  CameraRollEducationImage.swift
//  Slate
//
//  Created by John Coates on 5/17/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

struct CameraRollEducationImage: CanvasIcon {
    let width: CGFloat = 240
    let height: CGFloat = 205
    
    func drawing() {
        //// Color Declarations
        let fillColor4 = UIColor(red: 0.761, green: 0.914, blue: 0.976, alpha: 1.000)
        let fillColor5 = UIColor(red: 1.000, green: 0.361, blue: 0.278, alpha: 1.000)
        let fillColor6 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let strokeColor = UIColor(red: 0.329, green: 0.369, blue: 0.396, alpha: 1.000)
        let fillColor7 = UIColor(red: 0.988, green: 0.976, blue: 0.871, alpha: 1.000)
        let fillColor8 = UIColor(red: 0.329, green: 0.369, blue: 0.396, alpha: 1.000)
        let fillColor9 = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1.000)
        let fillColor10 = UIColor(red: 0.847, green: 0.941, blue: 0.784, alpha: 1.000)
        let fillColor11 = UIColor(red: 0.867, green: 0.878, blue: 0.886, alpha: 1.000)
        
        //// Group 2
        //// Polygon Drawing
        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint(x: 154, y: 0.2))
        polygonPath.addLine(to: CGPoint(x: 161.49, y: 13.17))
        polygonPath.addLine(to: CGPoint(x: 146.51, y: 13.18))
        polygonPath.close()
        fillColor4.setFill()
        polygonPath.fill()
        
        
        //// Polygon 2 Drawing
        let polygon2Path = UIBezierPath()
        polygon2Path.move(to: CGPoint(x: 133.5, y: 44.85))
        polygon2Path.addLine(to: CGPoint(x: 139.52, y: 48.32))
        polygon2Path.addLine(to: CGPoint(x: 139.52, y: 55.27))
        polygon2Path.addLine(to: CGPoint(x: 133.5, y: 58.75))
        polygon2Path.addLine(to: CGPoint(x: 127.48, y: 55.27))
        polygon2Path.addLine(to: CGPoint(x: 127.48, y: 48.32))
        polygon2Path.close()
        fillColor5.setFill()
        polygon2Path.fill()
        
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 25, y: 100, width: 146, height: 104), cornerRadius: 4)
        fillColor6.setFill()
        rectanglePath.fill()
        
        
        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(roundedRect: CGRect(x: 25, y: 100, width: 146, height: 104), cornerRadius: 4)
        strokeColor.setStroke()
        rectangle2Path.lineWidth = 4
        rectangle2Path.stroke()
        
        
        //// Rectangle 3 Drawing
        let rectangle3Path = UIBezierPath(rect: CGRect(x: 33, y: 108, width: 130, height: 88))
        fillColor7.setFill()
        rectangle3Path.fill()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 162, y: 119))
        bezierPath.addLine(to: CGPoint(x: 162, y: 109))
        bezierPath.addLine(to: CGPoint(x: 152, y: 109))
        strokeColor.setStroke()
        bezierPath.lineWidth = 2
        bezierPath.stroke()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 44, y: 109))
        bezier2Path.addLine(to: CGPoint(x: 34, y: 109))
        bezier2Path.addLine(to: CGPoint(x: 34, y: 119))
        strokeColor.setStroke()
        bezier2Path.lineWidth = 2
        bezier2Path.stroke()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 152, y: 195))
        bezier3Path.addLine(to: CGPoint(x: 162, y: 195))
        bezier3Path.addLine(to: CGPoint(x: 162, y: 185))
        strokeColor.setStroke()
        bezier3Path.lineWidth = 2
        bezier3Path.stroke()
        
        
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 34, y: 185))
        bezier4Path.addLine(to: CGPoint(x: 34, y: 195))
        bezier4Path.addLine(to: CGPoint(x: 44, y: 195))
        strokeColor.setStroke()
        bezier4Path.lineWidth = 2
        bezier4Path.stroke()
        
        
        //// Bezier 5 Drawing
        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: 71, y: 176))
        bezier5Path.addLine(to: CGPoint(x: 106.48, y: 140.52))
        bezier5Path.addCurve(to: CGPoint(x: 115.53, y: 140.52), controlPoint1: CGPoint(x: 108.97, y: 138.02), controlPoint2: CGPoint(x: 113.03, y: 138.02))
        bezier5Path.addLine(to: CGPoint(x: 151, y: 176))
        strokeColor.setStroke()
        bezier5Path.lineWidth = 2
        bezier5Path.stroke()
        
        
        //// Bezier 6 Drawing
        let bezier6Path = UIBezierPath()
        bezier6Path.move(to: CGPoint(x: 51, y: 166))
        bezier6Path.addLine(to: CGPoint(x: 66.47, y: 150.52))
        bezier6Path.addCurve(to: CGPoint(x: 75.52, y: 150.52), controlPoint1: CGPoint(x: 68.97, y: 148.02), controlPoint2: CGPoint(x: 73.02, y: 148.02))
        bezier6Path.addLine(to: CGPoint(x: 82.99, y: 158))
        strokeColor.setStroke()
        bezier6Path.lineWidth = 2
        bezier6Path.stroke()
        
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 48, y: 123, width: 8, height: 8))
        fillColor8.setFill()
        ovalPath.fill()
        
        
        //// Rectangle 4 Drawing
        let rectangle4Path = UIBezierPath(roundedRect: CGRect(x: 149, y: 45, width: 86, height: 96), cornerRadius: 9)
        fillColor9.setFill()
        rectangle4Path.fill()
        
        
        //// Rectangle 5 Drawing
        let rectangle5Path = UIBezierPath(roundedRect: CGRect(x: 154, y: 50, width: 76, height: 86), cornerRadius: 4)
        fillColor6.setFill()
        rectangle5Path.fill()
        
        
        //// Rectangle 6 Drawing
        let rectangle6Path = UIBezierPath(roundedRect: CGRect(x: 154, y: 50, width: 76, height: 86), cornerRadius: 4)
        strokeColor.setStroke()
        rectangle6Path.lineWidth = 2
        rectangle6Path.stroke()
        
        
        //// Rectangle 7 Drawing
        let rectangle7Path = UIBezierPath(rect: CGRect(x: 162, y: 58, width: 60, height: 60))
        fillColor10.setFill()
        rectangle7Path.fill()
        
        
        //// Bezier 7 Drawing
        let bezier7Path = UIBezierPath()
        bezier7Path.move(to: CGPoint(x: 199.12, y: 90.99))
        bezier7Path.addLine(to: CGPoint(x: 204.51, y: 90.99))
        bezier7Path.addLine(to: CGPoint(x: 196.94, y: 80.99))
        bezier7Path.addLine(to: CGPoint(x: 202.01, y: 80.99))
        bezier7Path.addLine(to: CGPoint(x: 192.01, y: 66.99))
        bezier7Path.addLine(to: CGPoint(x: 182.01, y: 80.99))
        bezier7Path.addLine(to: CGPoint(x: 187.09, y: 80.99))
        bezier7Path.addLine(to: CGPoint(x: 179.51, y: 90.99))
        bezier7Path.addLine(to: CGPoint(x: 184.91, y: 90.99))
        bezier7Path.addLine(to: CGPoint(x: 177.01, y: 101))
        bezier7Path.addLine(to: CGPoint(x: 189.01, y: 101))
        bezier7Path.addLine(to: CGPoint(x: 189.01, y: 109))
        bezier7Path.addLine(to: CGPoint(x: 195.01, y: 109))
        bezier7Path.addLine(to: CGPoint(x: 195.01, y: 101))
        bezier7Path.addLine(to: CGPoint(x: 207.01, y: 101))
        bezier7Path.addLine(to: CGPoint(x: 199.12, y: 90.99))
        bezier7Path.close()
        bezier7Path.usesEvenOddFillRule = true
        fillColor8.setFill()
        bezier7Path.fill()
        
        
        //// Bezier 8 Drawing
        let bezier8Path = UIBezierPath()
        bezier8Path.move(to: CGPoint(x: 9, y: 118.99))
        bezier8Path.addCurve(to: CGPoint(x: 0, y: 109.99), controlPoint1: CGPoint(x: 4.04, y: 118.99), controlPoint2: CGPoint(x: 0, y: 114.95))
        bezier8Path.addLine(to: CGPoint(x: 0, y: 31.99))
        bezier8Path.addCurve(to: CGPoint(x: 9, y: 22.99), controlPoint1: CGPoint(x: 0, y: 27.03), controlPoint2: CGPoint(x: 4.04, y: 22.99))
        bezier8Path.addLine(to: CGPoint(x: 76.99, y: 22.99))
        bezier8Path.addCurve(to: CGPoint(x: 85.99, y: 31.99), controlPoint1: CGPoint(x: 81.96, y: 22.99), controlPoint2: CGPoint(x: 85.99, y: 27.03))
        bezier8Path.addLine(to: CGPoint(x: 85.99, y: 109.99))
        bezier8Path.addCurve(to: CGPoint(x: 76.99, y: 118.99), controlPoint1: CGPoint(x: 85.99, y: 114.95), controlPoint2: CGPoint(x: 81.96, y: 118.99))
        bezier8Path.addLine(to: CGPoint(x: 9, y: 118.99))
        bezier8Path.close()
        bezier8Path.usesEvenOddFillRule = true
        fillColor9.setFill()
        bezier8Path.fill()
        
        
        //// Rectangle 8 Drawing
        let rectangle8Path = UIBezierPath(roundedRect: CGRect(x: 5, y: 28, width: 76, height: 86), cornerRadius: 4)
        fillColor6.setFill()
        rectangle8Path.fill()
        
        
        //// Rectangle 9 Drawing
        let rectangle9Path = UIBezierPath(roundedRect: CGRect(x: 5, y: 28, width: 76, height: 86), cornerRadius: 4)
        strokeColor.setStroke()
        rectangle9Path.lineWidth = 2
        rectangle9Path.stroke()
        
        
        //// Rectangle 10 Drawing
        let rectangle10Path = UIBezierPath(rect: CGRect(x: 13, y: 36, width: 60, height: 60))
        fillColor11.setFill()
        rectangle10Path.fill()
        
        
        //// Bezier 9 Drawing
        let bezier9Path = UIBezierPath()
        bezier9Path.move(to: CGPoint(x: 43, y: 66.1))
        bezier9Path.addCurve(to: CGPoint(x: 34, y: 64.1), controlPoint1: CGPoint(x: 38.03, y: 66.1), controlPoint2: CGPoint(x: 34, y: 65.21))
        bezier9Path.addCurve(to: CGPoint(x: 43, y: 62.1), controlPoint1: CGPoint(x: 34, y: 63), controlPoint2: CGPoint(x: 38.03, y: 62.1))
        bezier9Path.addCurve(to: CGPoint(x: 52, y: 64.1), controlPoint1: CGPoint(x: 47.97, y: 62.1), controlPoint2: CGPoint(x: 52, y: 63))
        bezier9Path.addCurve(to: CGPoint(x: 43, y: 66.1), controlPoint1: CGPoint(x: 52, y: 65.21), controlPoint2: CGPoint(x: 47.97, y: 66.1))
        bezier9Path.close()
        bezier9Path.move(to: CGPoint(x: 52.63, y: 51.1))
        bezier9Path.addCurve(to: CGPoint(x: 45.31, y: 52.79), controlPoint1: CGPoint(x: 49.89, y: 50.67), controlPoint2: CGPoint(x: 47.33, y: 51.37))
        bezier9Path.addCurve(to: CGPoint(x: 40.64, y: 52.74), controlPoint1: CGPoint(x: 43.93, y: 53.77), controlPoint2: CGPoint(x: 42.03, y: 53.7))
        bezier9Path.addCurve(to: CGPoint(x: 35.01, y: 50.98), controlPoint1: CGPoint(x: 39.04, y: 51.63), controlPoint2: CGPoint(x: 37.1, y: 50.98))
        bezier9Path.addCurve(to: CGPoint(x: 25, y: 60.98), controlPoint1: CGPoint(x: 29.48, y: 50.98), controlPoint2: CGPoint(x: 25, y: 55.46))
        bezier9Path.addLine(to: CGPoint(x: 25, y: 60.98))
        bezier9Path.addCurve(to: CGPoint(x: 43.01, y: 79), controlPoint1: CGPoint(x: 25, y: 70.93), controlPoint2: CGPoint(x: 33.06, y: 79))
        bezier9Path.addCurve(to: CGPoint(x: 60.94, y: 62.73), controlPoint1: CGPoint(x: 52.37, y: 79), controlPoint2: CGPoint(x: 60.07, y: 71.86))
        bezier9Path.addCurve(to: CGPoint(x: 52.63, y: 51.1), controlPoint1: CGPoint(x: 61.47, y: 57.24), controlPoint2: CGPoint(x: 58.08, y: 51.97))
        bezier9Path.close()
        bezier9Path.usesEvenOddFillRule = true
        fillColor5.setFill()
        bezier9Path.fill()
    }
}

