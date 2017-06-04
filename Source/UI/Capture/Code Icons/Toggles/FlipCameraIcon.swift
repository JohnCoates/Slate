//
//  FlipCameraIcon.swift
//  Slate
//
//  Created by John Coates on 5/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// codebeat:disable[ABC,ARITY,CYCLO,LOC,TOTAL_COMPLEXITY,TOTAL_LOC,TOO_MANY_IVARS]

import UIKit

struct FlippedCameraIcon: GroupedPathIcon {
    let width: CGFloat = 61.07
    let height: CGFloat = 56.17
    
    let paths: [CGPath] = {
        let bottomPath = UIBezierPath()
        bottomPath.move(to: CGPoint(x: 56.65, y: 34.27))
        bottomPath.addCurve(to: CGPoint(x: 54.91, y: 35.23), controlPoint1: CGPoint(x: 55.89, y: 34.07), controlPoint2: CGPoint(x: 55.13, y: 34.49))
        bottomPath.addCurve(to: CGPoint(x: 30.74, y: 53.37), controlPoint1: CGPoint(x: 51.8, y: 45.91), controlPoint2: CGPoint(x: 41.86, y: 53.37))
        bottomPath.addCurve(to: CGPoint(x: 7.47, y: 38.05), controlPoint1: CGPoint(x: 20.56, y: 53.37), controlPoint2: CGPoint(x: 11.39, y: 47.19))
        bottomPath.addLine(to: CGPoint(x: 13.71, y: 40.47))
        bottomPath.addCurve(to: CGPoint(x: 15.52, y: 39.68), controlPoint1: CGPoint(x: 14.43, y: 40.75), controlPoint2: CGPoint(x: 15.24, y: 40.4))
        bottomPath.addCurve(to: CGPoint(x: 14.72, y: 37.86), controlPoint1: CGPoint(x: 15.8, y: 38.95), controlPoint2: CGPoint(x: 15.44, y: 38.14))
        bottomPath.addLine(to: CGPoint(x: 5.59, y: 34.32))
        bottomPath.addCurve(to: CGPoint(x: 5.41, y: 34.29), controlPoint1: CGPoint(x: 5.53, y: 34.29), controlPoint2: CGPoint(x: 5.47, y: 34.3))
        bottomPath.addCurve(to: CGPoint(x: 5.15, y: 34.24), controlPoint1: CGPoint(x: 5.33, y: 34.26), controlPoint2: CGPoint(x: 5.25, y: 34.25))
        bottomPath.addCurve(to: CGPoint(x: 4.85, y: 34.26), controlPoint1: CGPoint(x: 5.05, y: 34.24), controlPoint2: CGPoint(x: 4.95, y: 34.25))
        bottomPath.addCurve(to: CGPoint(x: 4.69, y: 34.27), controlPoint1: CGPoint(x: 4.8, y: 34.27), controlPoint2: CGPoint(x: 4.74, y: 34.26))
        bottomPath.addCurve(to: CGPoint(x: 4.61, y: 34.32), controlPoint1: CGPoint(x: 4.66, y: 34.28), controlPoint2: CGPoint(x: 4.64, y: 34.31))
        bottomPath.addCurve(to: CGPoint(x: 4.35, y: 34.45), controlPoint1: CGPoint(x: 4.52, y: 34.35), controlPoint2: CGPoint(x: 4.43, y: 34.4))
        bottomPath.addCurve(to: CGPoint(x: 4.14, y: 34.6), controlPoint1: CGPoint(x: 4.28, y: 34.5), controlPoint2: CGPoint(x: 4.21, y: 34.54))
        bottomPath.addCurve(to: CGPoint(x: 3.97, y: 34.8), controlPoint1: CGPoint(x: 4.08, y: 34.66), controlPoint2: CGPoint(x: 4.03, y: 34.73))
        bottomPath.addCurve(to: CGPoint(x: 3.82, y: 35.04), controlPoint1: CGPoint(x: 3.92, y: 34.88), controlPoint2: CGPoint(x: 3.86, y: 34.95))
        bottomPath.addCurve(to: CGPoint(x: 3.77, y: 35.12), controlPoint1: CGPoint(x: 3.81, y: 35.07), controlPoint2: CGPoint(x: 3.78, y: 35.09))
        bottomPath.addLine(to: CGPoint(x: 0.1, y: 44.58))
        bottomPath.addCurve(to: CGPoint(x: 0.89, y: 46.39), controlPoint1: CGPoint(x: -0.18, y: 45.3), controlPoint2: CGPoint(x: 0.17, y: 46.12))
        bottomPath.addCurve(to: CGPoint(x: 1.4, y: 46.49), controlPoint1: CGPoint(x: 1.06, y: 46.46), controlPoint2: CGPoint(x: 1.23, y: 46.49))
        bottomPath.addCurve(to: CGPoint(x: 2.71, y: 45.59), controlPoint1: CGPoint(x: 1.96, y: 46.49), controlPoint2: CGPoint(x: 2.49, y: 46.15))
        bottomPath.addLine(to: CGPoint(x: 5.06, y: 39.55))
        bottomPath.addCurve(to: CGPoint(x: 30.73, y: 56.17), controlPoint1: CGPoint(x: 9.51, y: 49.49), controlPoint2: CGPoint(x: 19.57, y: 56.17))
        bottomPath.addCurve(to: CGPoint(x: 57.6, y: 36.02), controlPoint1: CGPoint(x: 43.09, y: 56.17), controlPoint2: CGPoint(x: 54.13, y: 47.88))
        bottomPath.addCurve(to: CGPoint(x: 56.65, y: 34.27), controlPoint1: CGPoint(x: 57.82, y: 35.27), controlPoint2: CGPoint(x: 57.39, y: 34.49))
        bottomPath.addLine(to: CGPoint(x: 56.65, y: 34.27))
        bottomPath.close()
        
        //// top Drawing
        let topPath = UIBezierPath()
        topPath.move(to: CGPoint(x: 60.18, y: 9.78))
        topPath.addCurve(to: CGPoint(x: 58.37, y: 10.58), controlPoint1: CGPoint(x: 59.45, y: 9.5), controlPoint2: CGPoint(x: 58.64, y: 9.85))
        topPath.addLine(to: CGPoint(x: 56.02, y: 16.62))
        topPath.addCurve(to: CGPoint(x: 30.34, y: 0), controlPoint1: CGPoint(x: 51.56, y: 6.68), controlPoint2: CGPoint(x: 41.5, y: 0))
        topPath.addCurve(to: CGPoint(x: 3.48, y: 20.15), controlPoint1: CGPoint(x: 17.99, y: 0), controlPoint2: CGPoint(x: 6.94, y: 8.29))
        topPath.addCurve(to: CGPoint(x: 4.43, y: 21.89), controlPoint1: CGPoint(x: 3.26, y: 20.9), controlPoint2: CGPoint(x: 3.69, y: 21.68))
        topPath.addCurve(to: CGPoint(x: 6.17, y: 20.94), controlPoint1: CGPoint(x: 5.19, y: 22.11), controlPoint2: CGPoint(x: 5.95, y: 21.68))
        topPath.addCurve(to: CGPoint(x: 30.34, y: 2.8), controlPoint1: CGPoint(x: 9.28, y: 10.26), controlPoint2: CGPoint(x: 19.22, y: 2.8))
        topPath.addCurve(to: CGPoint(x: 53.61, y: 18.12), controlPoint1: CGPoint(x: 40.52, y: 2.8), controlPoint2: CGPoint(x: 49.69, y: 8.98))
        topPath.addLine(to: CGPoint(x: 47.37, y: 15.69))
        topPath.addCurve(to: CGPoint(x: 45.56, y: 16.49), controlPoint1: CGPoint(x: 46.65, y: 15.42), controlPoint2: CGPoint(x: 45.84, y: 15.77))
        topPath.addCurve(to: CGPoint(x: 46.36, y: 18.31), controlPoint1: CGPoint(x: 45.27, y: 17.22), controlPoint2: CGPoint(x: 45.63, y: 18.03))
        topPath.addLine(to: CGPoint(x: 55.49, y: 21.86))
        topPath.addCurve(to: CGPoint(x: 56, y: 21.95), controlPoint1: CGPoint(x: 55.66, y: 21.92), controlPoint2: CGPoint(x: 55.83, y: 21.95))
        topPath.addCurve(to: CGPoint(x: 56.39, y: 21.89), controlPoint1: CGPoint(x: 56.13, y: 21.95), controlPoint2: CGPoint(x: 56.26, y: 21.93))
        topPath.addCurve(to: CGPoint(x: 56.68, y: 21.74), controlPoint1: CGPoint(x: 56.5, y: 21.86), controlPoint2: CGPoint(x: 56.59, y: 21.8))
        topPath.addCurve(to: CGPoint(x: 56.81, y: 21.67), controlPoint1: CGPoint(x: 56.73, y: 21.72), controlPoint2: CGPoint(x: 56.77, y: 21.7))
        topPath.addCurve(to: CGPoint(x: 57.27, y: 21.1), controlPoint1: CGPoint(x: 57.02, y: 21.52), controlPoint2: CGPoint(x: 57.17, y: 21.33))
        topPath.addCurve(to: CGPoint(x: 57.31, y: 21.06), controlPoint1: CGPoint(x: 57.27, y: 21.08), controlPoint2: CGPoint(x: 57.3, y: 21.08))
        topPath.addLine(to: CGPoint(x: 60.98, y: 11.59))
        topPath.addCurve(to: CGPoint(x: 60.18, y: 9.78), controlPoint1: CGPoint(x: 61.26, y: 10.87), controlPoint2: CGPoint(x: 60.9, y: 10.06))
        topPath.addLine(to: CGPoint(x: 60.18, y: 9.78))
        topPath.close()

        return [bottomPath.cgPath, topPath.cgPath]
    }()
}
