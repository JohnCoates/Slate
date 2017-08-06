//
//  VectorImageCanvasIcon.swift
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable function_body_length cyclomatic_complexity

import UIKit

class VectorImageCanvasIcon: CanvasIcon {
    
    let canvas: Canvas
    var width: CGFloat { return CGFloat(self.canvas.width) }
    var height: CGFloat { return CGFloat(self.canvas.height) }
    var size: CGSize {
        return CGSize(width: self.width, height: self.height)
    }
    
    convenience init(asset: ImageAsset) {
        let canvas = Canvas.from(asset: asset)
        self.init(canvas: canvas)
    }
    
    init(canvas: Canvas) {
        self.canvas = canvas
    }
    
    func drawing() {
        if canvas.instructions.count > 0 {
            execute(canvasInstructions: canvas.instructions)
        }
        for path in canvas.paths {
            draw(path: path)
        }
        ephemeralContext = nil
    }
    
    var ephemeralContext: CGContext?
    
    var context: CGContext {
        if let context = ephemeralContext {
            return context
        } else {
            guard let context = UIGraphicsGetCurrentContext() else {
                fatalError("Couldn't get graphics context!")
            }
            
            ephemeralContext = context
            return context
        }
    }
    
    func execute(canvasInstructions: [Path.Instruction]) {
        for instruction in canvasInstructions {
            switch instruction {
            case .contextSaveGState:
                context.saveGState()
            case .contextRestoreGState:
                context.restoreGState()
            case .contextTranslateBy(let x, let y):
                context.translateBy(x: CGFloat(x), y: CGFloat(y))
            case .contextRotate(let by):
                context.rotate(by: CGFloat(by))
            case .initWith, .initWith2, .initWith3,
                 .move, .addLine, .addCurve, .close,
                 .fill, .stroke, .setLineWidth,
                 .usesEvenOddFillRule, .setLineCapStyle:
                fatalError("Invalid instruction for canvas")
            }
        }
    }

    func draw(path codePath: Path) {
        var instructions = codePath.instructions
        let first = instructions.removeFirst()
        
        let path: UIBezierPath
        switch first {
        case .initWith(let rect):
            path = UIBezierPath(rect: rect.cgRect)
        case .initWith2(let rect, let cornerRadius):
            path = UIBezierPath(roundedRect: rect.cgRect, cornerRadius: CGFloat(cornerRadius))
        case .initWith3(let ovalIn):
            path = UIBezierPath(ovalIn: ovalIn.cgRect)
        default:
            path = UIBezierPath()
            instructions.insert(first, at: 0)
        }
        
        for instruction in instructions {
            switch instruction {
            case .move(let to):
                path.move(to: to.cgPoint)
            case .addLine(let to):
                path.addLine(to: to.cgPoint)
            case .addCurve(let to, let control1, let control2):
                path.addCurve(to: to.cgPoint,
                              controlPoint1: control1.cgPoint,
                              controlPoint2: control2.cgPoint)
            case .close:
                path.close()
            case .fill(let color):
                let uiColor: UIColor = color.uiColor
                uiColor.setFill()
                path.fill()
            case .stroke(color: let color):
                let uiColor: UIColor = color.uiColor
                uiColor.setStroke()
                path.stroke()
            case .setLineWidth(let to):
                path.lineWidth = CGFloat(to)
            case .setLineCapStyle(let to):
                path.lineCapStyle = to.cgLineCap
            case .usesEvenOddFillRule:
                path.usesEvenOddFillRule = true
            case .initWith, .initWith2, .initWith3:
                fatalError("Unexpected double init")
            // Graphics Context
            case .contextSaveGState:
                context.saveGState()
            case .contextRestoreGState:
                context.restoreGState()
            case .contextTranslateBy(let x, let y):
                context.translateBy(x: CGFloat(x), y: CGFloat(y))
            case .contextRotate(let by):
                context.rotate(by: CGFloat(by))
            }
        }
    }
    
}

extension Path.Color {
    var uiColor: UIColor {
        return UIColor(red: CGFloat(self.red),
                       green: CGFloat(self.green),
                       blue: CGFloat(self.blue),
                       alpha: CGFloat(self.alpha))
    }
}

extension Path.Point {
    var cgPoint: CGPoint {
        return CGPoint(x: CGFloat(self.x), y: CGFloat(self.y))
    }
}

extension Path.Rect {
    var cgRect: CGRect {
        return CGRect(x: CGFloat(self.origin.x),
                      y: CGFloat(self.origin.y),
                      width: CGFloat(self.size.x),
                      height: CGFloat(self.size.y))
    }
}

extension Path.LineCapStyle {
    var cgLineCap: CGLineCap {
        switch self {
        case .butt:
            return .butt
        case .round:
            return .round
        case .square:
            return .square
        }
    }
}
