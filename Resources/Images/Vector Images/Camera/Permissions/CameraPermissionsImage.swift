//
//  CameraPermissionsImage.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// codebeat:disable[ABC,ARITY,CYCLO,LOC,TOTAL_COMPLEXITY,TOTAL_LOC,TOO_MANY_IVARS]

import Foundation

extension DrawProxyDSL {
    class CameraPermissionsImage: VectorImageAsset {

        let asset = PermissionsImage.camera
        let width: CGFloat = 167
        let height: CGFloat = 204
        
        lazy var name: String = self.asset.rawValue
        lazy var section: String = self.asset.section
        
        func simulateDraw() {
            //// General Declarations
            let context = UIGraphicsGetCurrentContext()!
            
            //// Color Declarations
            let fillColor4 = UIColor(red: 0.761, green: 0.914, blue: 0.976, alpha: 1.000)
            let fillColor5 = UIColor(red: 1.000, green: 0.361, blue: 0.278, alpha: 1.000)
            let strokeColor = UIColor(red: 0.329, green: 0.369, blue: 0.396, alpha: 1.000)
            let fillColor8 = UIColor(red: 0.329, green: 0.369, blue: 0.396, alpha: 1.000)
            let fillColor9 = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1.000)
            
            //// Group 2
            //// Bezier Drawing
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 32, y: 109))
            bezierPath.addLine(to: CGPoint(x: 32, y: 107))
            bezierPath.addCurve(to: CGPoint(x: 28, y: 103), controlPoint1: CGPoint(x: 32, y: 104.79), controlPoint2: CGPoint(x: 30.21, y: 103))
            bezierPath.addLine(to: CGPoint(x: 16, y: 103))
            bezierPath.addCurve(to: CGPoint(x: 12, y: 107), controlPoint1: CGPoint(x: 13.79, y: 103), controlPoint2: CGPoint(x: 12, y: 104.79))
            bezierPath.addLine(to: CGPoint(x: 12, y: 109))
            bezierPath.usesEvenOddFillRule = true
            fillColor4.setFill()
            bezierPath.fill()
            
            
            //// Bezier 2 Drawing
            let bezier2Path = UIBezierPath()
            bezier2Path.move(to: CGPoint(x: 32, y: 109))
            bezier2Path.addLine(to: CGPoint(x: 32, y: 107))
            bezier2Path.addCurve(to: CGPoint(x: 28, y: 103), controlPoint1: CGPoint(x: 32, y: 104.79), controlPoint2: CGPoint(x: 30.21, y: 103))
            bezier2Path.addLine(to: CGPoint(x: 16, y: 103))
            bezier2Path.addCurve(to: CGPoint(x: 12, y: 107), controlPoint1: CGPoint(x: 13.79, y: 103), controlPoint2: CGPoint(x: 12, y: 104.79))
            bezier2Path.addLine(to: CGPoint(x: 12, y: 109))
            strokeColor.setStroke()
            bezier2Path.lineWidth = 2
            bezier2Path.stroke()
            
            
            //// Rectangle Drawing
            let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 113, width: 150, height: 90), cornerRadius: 6)
            fillColor9.setFill()
            rectanglePath.fill()
            
            
            //// Rectangle 2 Drawing
            let rectangle2Path = UIBezierPath(roundedRect: CGRect(x: 7, y: 120, width: 144, height: 84), cornerRadius: 3)
            fillColor4.setFill()
            rectangle2Path.fill()
            
            
            //// Rectangle 3 Drawing
            let rectangle3Path = UIBezierPath(roundedRect: CGRect(x: 0, y: 113, width: 150, height: 90), cornerRadius: 6)
            strokeColor.setStroke()
            rectangle3Path.lineWidth = 4
            rectangle3Path.stroke()
            
            
            //// Rectangle 4 Drawing
            let rectangle4Path = UIBezierPath(roundedRect: CGRect(x: 13, y: 125, width: 20, height: 10), cornerRadius: 5)
            fillColor8.setFill()
            rectangle4Path.fill()
            
            
            //// Rectangle 5 Drawing
            let rectangle5Path = UIBezierPath(rect: CGRect(x: 7, y: 140, width: 141, height: 36))
            fillColor5.setFill()
            rectangle5Path.fill()
            
            
            //// Oval Drawing
            let ovalPath = UIBezierPath(ovalIn: CGRect(x: 78, y: 132, width: 60, height: 60))
            fillColor8.setFill()
            ovalPath.fill()
            
            
            //// Oval 2 Drawing
            let oval2Path = UIBezierPath(ovalIn: CGRect(x: 74, y: 128, width: 60, height: 60))
            fillColor4.setFill()
            oval2Path.fill()
            
            
            //// Bezier 3 Drawing
            let bezier3Path = UIBezierPath()
            bezier3Path.move(to: CGPoint(x: 123.12, y: 134.88))
            bezier3Path.addCurve(to: CGPoint(x: 130, y: 154), controlPoint1: CGPoint(x: 127.42, y: 140.07), controlPoint2: CGPoint(x: 130, y: 146.73))
            bezier3Path.addCurve(to: CGPoint(x: 100, y: 184), controlPoint1: CGPoint(x: 130, y: 170.57), controlPoint2: CGPoint(x: 116.57, y: 184))
            bezier3Path.addCurve(to: CGPoint(x: 80.88, y: 177.12), controlPoint1: CGPoint(x: 92.73, y: 184), controlPoint2: CGPoint(x: 86.07, y: 181.42))
            bezier3Path.addCurve(to: CGPoint(x: 104, y: 188), controlPoint1: CGPoint(x: 86.38, y: 183.76), controlPoint2: CGPoint(x: 94.7, y: 188))
            bezier3Path.addCurve(to: CGPoint(x: 134, y: 158), controlPoint1: CGPoint(x: 120.57, y: 188), controlPoint2: CGPoint(x: 134, y: 174.57))
            bezier3Path.addCurve(to: CGPoint(x: 123.12, y: 134.88), controlPoint1: CGPoint(x: 134, y: 148.7), controlPoint2: CGPoint(x: 129.76, y: 140.38))
            bezier3Path.close()
            bezier3Path.usesEvenOddFillRule = true
            fillColor9.setFill()
            bezier3Path.fill()
            
            
            //// Oval 3 Drawing
            let oval3Path = UIBezierPath(ovalIn: CGRect(x: 89, y: 143, width: 30, height: 30))
            fillColor8.setFill()
            oval3Path.fill()
            
            
            //// Oval 4 Drawing
            let oval4Path = UIBezierPath(ovalIn: CGRect(x: 74, y: 128, width: 60, height: 60))
            strokeColor.setStroke()
            oval4Path.lineWidth = 2
            oval4Path.stroke()
            
            
            //// Bezier 4 Drawing
            let bezier4Path = UIBezierPath()
            bezier4Path.move(to: CGPoint(x: 129.75, y: 101.75))
            bezier4Path.addLine(to: CGPoint(x: 129.75, y: 81.75))
            bezier4Path.addLine(to: CGPoint(x: 81, y: 82))
            bezier4Path.addLine(to: CGPoint(x: 81, y: 102))
            bezier4Path.usesEvenOddFillRule = true
            fillColor4.setFill()
            bezier4Path.fill()
            
            
            //// Bezier 5 Drawing
            let bezier5Path = UIBezierPath()
            bezier5Path.move(to: CGPoint(x: 78, y: 82))
            bezier5Path.addLine(to: CGPoint(x: 78, y: 102))
            bezier5Path.addLine(to: CGPoint(x: 129.75, y: 101.75))
            bezier5Path.addLine(to: CGPoint(x: 129.75, y: 81.75))
            strokeColor.setStroke()
            bezier5Path.lineWidth = 2
            bezier5Path.stroke()
            
            
            //// Rectangle 6 Drawing
            context.saveGState()
            context.translateBy(x: 103.9, y: 66.85)
            context.rotate(by: -0.25 * CGFloat.pi/180)
            
            let rectangle6Path = UIBezierPath(rect: CGRect(x: -23.88, y: -9, width: 47.75, height: 18))
            fillColor9.setFill()
            rectangle6Path.fill()
            
            context.restoreGState()
            
            
            //// Rectangle 7 Drawing
            context.saveGState()
            context.translateBy(x: 103.9, y: 66.85)
            context.rotate(by: -0.25 * CGFloat.pi/180)
            
            let rectangle7Path = UIBezierPath(rect: CGRect(x: -23.88, y: -9, width: 47.75, height: 18))
            strokeColor.setStroke()
            rectangle7Path.lineWidth = 2
            rectangle7Path.stroke()
            
            context.restoreGState()
            
            
            //// Bezier 6 Drawing
            let bezier6Path = UIBezierPath()
            bezier6Path.move(to: CGPoint(x: 127.75, y: 75.77))
            bezier6Path.addLine(to: CGPoint(x: 80, y: 75.97))
            bezier6Path.addLine(to: CGPoint(x: 80, y: 57.97))
            bezier6Path.addLine(to: CGPoint(x: 127.75, y: 57.77))
            bezier6Path.addLine(to: CGPoint(x: 127.75, y: 75.77))
            bezier6Path.close()
            bezier6Path.move(to: CGPoint(x: 129.74, y: 51.76))
            bezier6Path.addLine(to: CGPoint(x: 77.98, y: 51.98))
            bezier6Path.addCurve(to: CGPoint(x: 74, y: 55.98), controlPoint1: CGPoint(x: 75.78, y: 51.99), controlPoint2: CGPoint(x: 74, y: 53.78))
            bezier6Path.addLine(to: CGPoint(x: 74, y: 77.98))
            bezier6Path.addCurve(to: CGPoint(x: 78.01, y: 81.98), controlPoint1: CGPoint(x: 74, y: 80.2), controlPoint2: CGPoint(x: 75.8, y: 81.99))
            bezier6Path.addLine(to: CGPoint(x: 129.77, y: 81.76))
            bezier6Path.addCurve(to: CGPoint(x: 133.75, y: 77.76), controlPoint1: CGPoint(x: 131.97, y: 81.75), controlPoint2: CGPoint(x: 133.75, y: 79.96))
            bezier6Path.addLine(to: CGPoint(x: 133.75, y: 55.76))
            bezier6Path.addCurve(to: CGPoint(x: 129.74, y: 51.76), controlPoint1: CGPoint(x: 133.75, y: 53.54), controlPoint2: CGPoint(x: 131.95, y: 51.75))
            bezier6Path.addLine(to: CGPoint(x: 129.74, y: 51.76))
            bezier6Path.close()
            bezier6Path.usesEvenOddFillRule = true
            fillColor9.setFill()
            bezier6Path.fill()
            
            
            //// Bezier 7 Drawing
            let bezier7Path = UIBezierPath()
            bezier7Path.move(to: CGPoint(x: 79, y: 56.98))
            bezier7Path.addLine(to: CGPoint(x: 79, y: 78.98))
            bezier7Path.addLine(to: CGPoint(x: 130.75, y: 78.76))
            bezier7Path.addLine(to: CGPoint(x: 130.75, y: 56.76))
            bezier7Path.addLine(to: CGPoint(x: 79, y: 56.98))
            bezier7Path.close()
            bezier7Path.move(to: CGPoint(x: 79, y: 80.98))
            bezier7Path.addCurve(to: CGPoint(x: 77, y: 78.98), controlPoint1: CGPoint(x: 77.89, y: 80.98), controlPoint2: CGPoint(x: 77, y: 80.08))
            bezier7Path.addLine(to: CGPoint(x: 77, y: 56.98))
            bezier7Path.addCurve(to: CGPoint(x: 78.99, y: 54.98), controlPoint1: CGPoint(x: 77, y: 55.88), controlPoint2: CGPoint(x: 77.89, y: 54.98))
            bezier7Path.addLine(to: CGPoint(x: 130.75, y: 54.76))
            bezier7Path.addCurve(to: CGPoint(x: 132.75, y: 56.76), controlPoint1: CGPoint(x: 131.86, y: 54.76), controlPoint2: CGPoint(x: 132.75, y: 55.66))
            bezier7Path.addLine(to: CGPoint(x: 132.75, y: 78.76))
            bezier7Path.addCurve(to: CGPoint(x: 130.76, y: 80.76), controlPoint1: CGPoint(x: 132.75, y: 79.86), controlPoint2: CGPoint(x: 131.86, y: 80.76))
            bezier7Path.addLine(to: CGPoint(x: 79, y: 80.98))
            bezier7Path.close()
            bezier7Path.usesEvenOddFillRule = true
            fillColor4.setFill()
            bezier7Path.fill()
            
            
            //// Bezier 8 Drawing
            let bezier8Path = UIBezierPath()
            bezier8Path.move(to: CGPoint(x: 127.75, y: 75.77))
            bezier8Path.addLine(to: CGPoint(x: 80, y: 75.97))
            bezier8Path.addLine(to: CGPoint(x: 80, y: 57.97))
            bezier8Path.addLine(to: CGPoint(x: 127.75, y: 57.77))
            bezier8Path.addLine(to: CGPoint(x: 127.75, y: 75.77))
            bezier8Path.addLine(to: CGPoint(x: 127.75, y: 75.77))
            bezier8Path.close()
            bezier8Path.move(to: CGPoint(x: 129.74, y: 51.76))
            bezier8Path.addLine(to: CGPoint(x: 77.98, y: 51.98))
            bezier8Path.addCurve(to: CGPoint(x: 74, y: 55.98), controlPoint1: CGPoint(x: 75.78, y: 51.99), controlPoint2: CGPoint(x: 74, y: 53.78))
            bezier8Path.addLine(to: CGPoint(x: 74, y: 77.98))
            bezier8Path.addCurve(to: CGPoint(x: 78.01, y: 81.98), controlPoint1: CGPoint(x: 74, y: 80.2), controlPoint2: CGPoint(x: 75.8, y: 81.99))
            bezier8Path.addLine(to: CGPoint(x: 129.77, y: 81.76))
            bezier8Path.addCurve(to: CGPoint(x: 133.75, y: 77.76), controlPoint1: CGPoint(x: 131.97, y: 81.75), controlPoint2: CGPoint(x: 133.75, y: 79.96))
            bezier8Path.addLine(to: CGPoint(x: 133.75, y: 55.76))
            bezier8Path.addCurve(to: CGPoint(x: 129.74, y: 51.76), controlPoint1: CGPoint(x: 133.75, y: 53.54), controlPoint2: CGPoint(x: 131.95, y: 51.75))
            bezier8Path.addLine(to: CGPoint(x: 129.74, y: 51.76))
            bezier8Path.close()
            strokeColor.setStroke()
            bezier8Path.lineWidth = 2
            bezier8Path.stroke()
            
            
            //// Bezier 9 Drawing
            let bezier9Path = UIBezierPath()
            bezier9Path.move(to: CGPoint(x: 80, y: 66.87))
            bezier9Path.addLine(to: CGPoint(x: 127.75, y: 66.87))
            strokeColor.setStroke()
            bezier9Path.lineWidth = 2
            bezier9Path.stroke()
            
            
            //// Bezier 10 Drawing
            let bezier10Path = UIBezierPath()
            bezier10Path.move(to: CGPoint(x: 119, y: 109))
            bezier10Path.addLine(to: CGPoint(x: 119, y: 102))
            bezier10Path.addLine(to: CGPoint(x: 89, y: 102))
            bezier10Path.addLine(to: CGPoint(x: 89, y: 109))
            bezier10Path.usesEvenOddFillRule = true
            fillColor4.setFill()
            bezier10Path.fill()
            
            
            //// Bezier 11 Drawing
            let bezier11Path = UIBezierPath()
            bezier11Path.move(to: CGPoint(x: 119, y: 109))
            bezier11Path.addLine(to: CGPoint(x: 119, y: 102))
            bezier11Path.addLine(to: CGPoint(x: 89, y: 102))
            bezier11Path.addLine(to: CGPoint(x: 89, y: 109))
            strokeColor.setStroke()
            bezier11Path.lineWidth = 2
            bezier11Path.stroke()
            
            
            //// Bezier 12 Drawing
            let bezier12Path = UIBezierPath()
            bezier12Path.move(to: CGPoint(x: 129.02, y: 25.46))
            bezier12Path.addCurve(to: CGPoint(x: 124.02, y: 20.46), controlPoint1: CGPoint(x: 126.26, y: 25.46), controlPoint2: CGPoint(x: 124.02, y: 23.23))
            bezier12Path.addCurve(to: CGPoint(x: 119.02, y: 25.46), controlPoint1: CGPoint(x: 124.02, y: 23.23), controlPoint2: CGPoint(x: 121.78, y: 25.46))
            bezier12Path.addCurve(to: CGPoint(x: 124.02, y: 30.46), controlPoint1: CGPoint(x: 121.78, y: 25.46), controlPoint2: CGPoint(x: 124.02, y: 27.7))
            bezier12Path.addCurve(to: CGPoint(x: 129.02, y: 25.46), controlPoint1: CGPoint(x: 124.02, y: 27.7), controlPoint2: CGPoint(x: 126.26, y: 25.46))
            bezier12Path.close()
            bezier12Path.usesEvenOddFillRule = true
            fillColor5.setFill()
            bezier12Path.fill()
            
            
            //// Bezier 13 Drawing
            let bezier13Path = UIBezierPath()
            bezier13Path.move(to: CGPoint(x: 167.43, y: 6.36))
            bezier13Path.addCurve(to: CGPoint(x: 161.43, y: 0.36), controlPoint1: CGPoint(x: 164.11, y: 6.36), controlPoint2: CGPoint(x: 161.43, y: 3.68))
            bezier13Path.addCurve(to: CGPoint(x: 155.43, y: 6.36), controlPoint1: CGPoint(x: 161.43, y: 3.68), controlPoint2: CGPoint(x: 158.74, y: 6.36))
            bezier13Path.addCurve(to: CGPoint(x: 161.43, y: 12.36), controlPoint1: CGPoint(x: 158.74, y: 6.36), controlPoint2: CGPoint(x: 161.43, y: 9.05))
            bezier13Path.addCurve(to: CGPoint(x: 167.43, y: 6.36), controlPoint1: CGPoint(x: 161.43, y: 9.05), controlPoint2: CGPoint(x: 164.11, y: 6.36))
            bezier13Path.close()
            bezier13Path.usesEvenOddFillRule = true
            fillColor4.setFill()
            bezier13Path.fill()
            
            
            //// Bezier 14 Drawing
            let bezier14Path = UIBezierPath()
            bezier14Path.move(to: CGPoint(x: 162.35, y: 63.03))
            bezier14Path.addCurve(to: CGPoint(x: 152.35, y: 53.03), controlPoint1: CGPoint(x: 156.83, y: 63.03), controlPoint2: CGPoint(x: 152.35, y: 58.55))
            bezier14Path.addCurve(to: CGPoint(x: 142.35, y: 63.03), controlPoint1: CGPoint(x: 152.35, y: 58.55), controlPoint2: CGPoint(x: 147.87, y: 63.03))
            bezier14Path.addCurve(to: CGPoint(x: 152.35, y: 73.03), controlPoint1: CGPoint(x: 147.87, y: 63.03), controlPoint2: CGPoint(x: 152.35, y: 67.51))
            bezier14Path.addCurve(to: CGPoint(x: 162.35, y: 63.03), controlPoint1: CGPoint(x: 152.35, y: 67.51), controlPoint2: CGPoint(x: 156.83, y: 63.03))
            bezier14Path.close()
            bezier14Path.usesEvenOddFillRule = true
            fillColor8.setFill()
            bezier14Path.fill()

        }
    }
}
