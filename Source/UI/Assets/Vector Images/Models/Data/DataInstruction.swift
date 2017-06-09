//
//  Instruction.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension VectorImage {
    enum DataInstruction {
        case move(to: DataPoint)
        case addLine(to: DataPoint)
        case addCurve(to: DataPoint, control1: DataPoint, control2: DataPoint)
        case close
        case fill(color: DataColor)
        case stroke(color: DataColor)
        case setLineWidth(toFloatIndex: UInt16)
        case usesEvenOddFillRule
        
        case initWith(rect: DataRect)
        case initWith2(rect: DataRect, cornerRadiusIndex: UInt16)
        case initWith3(ovalIn: DataRect)
        
        enum Kind: UInt8 {
            case move = 0
            case addLine = 1
            case addCurve = 2
            case close = 3
            case fill = 4
            case stroke = 5
            case setLineWidth = 6
            case usesEvenOddFillRule = 7
            case initWith = 8
            case initWith2 = 9
            case initWith3 = 10
        }
        
        var type: UInt8 {
            switch self {
            case .move(_):
                return Kind.move.rawValue
            case .addLine(_):
                return Kind.addLine.rawValue
            case .addCurve(_):
                return Kind.addCurve.rawValue
            case .close:
                return Kind.close.rawValue
            case .fill(_):
                return Kind.fill.rawValue
            case .stroke(_):
                return Kind.stroke.rawValue
            case .setLineWidth(_):
                return Kind.setLineWidth.rawValue
            case .usesEvenOddFillRule:
                return Kind.usesEvenOddFillRule.rawValue
            case .initWith(_):
                return Kind.initWith.rawValue
            case .initWith2(_):
                return Kind.initWith2.rawValue
            case .initWith3(_):
                return Kind.initWith3.rawValue
            }
        }
    }
}
