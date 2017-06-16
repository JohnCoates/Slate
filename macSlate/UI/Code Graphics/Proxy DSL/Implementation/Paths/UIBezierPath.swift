//
//  UIBezierPath.swift
//  Slate
//
//  Created by John Coates on 6/3/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension DrawProxyDSL {
    class UIBezierPath {
        
        let path = Path()
        init() {
            DrawProxyDSL.currentPath = path
            DrawProxyDSL.canvas!.paths.append(path)
        }
        
        convenience init(rect: CGRect) {
            self.init()
            path.add(instruction: .initWith(rect: rect.rect))
        }
        
        convenience init(roundedRect rect: CGRect, cornerRadius: Float) {
            self.init()
            path.add(instruction: .initWith2(rect: rect.rect, cornerRadius: cornerRadius))
        }
        
        convenience init(ovalIn rect: CGRect) {
            self.init()
            path.add(instruction: .initWith3(ovalIn: rect.rect))
        }
        
        func move(to: CGPoint) {
            path.add(instruction: .move(to: to.point))
            
        }
        
        func addCurve(to: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
            path.add(instruction: .addCurve(to: to.point,
                                            control1: controlPoint1.point,
                                            control2: controlPoint2.point))
        }
        
        func addLine(to: CGPoint) {
            path.add(instruction: .addLine(to: to.point))
        }
        
        func close() {
            path.add(instruction: .close)
        }
        
        func fill() {
            guard let color = currentFill else {
                fatalError("No fill color set!")
            }
            path.add(instruction: .fill(color: color))
        }
        
        func stroke() {
            guard let color = currentStroke else {
                fatalError("No stroke color set!")
            }
            path.add(instruction: .stroke(color: color))
        }
        
        var usesEvenOddFillRule = false {
            didSet {
                if usesEvenOddFillRule {
                    path.add(instruction: .usesEvenOddFillRule)
                }
            }
        }
        
        var lineWidth: Float? {
            didSet {
                if let lineWidth = lineWidth {
                    path.add(instruction: .setLineWidth(to: lineWidth))
                }
            }
        }
        
        var lineCapStyle: Path.LineCapStyle? {
            didSet {
                if let lineCapStyle = lineCapStyle {
                    path.add(instruction: .setLineCapStyle(to: lineCapStyle))
                }
            }
        }
    }
}
