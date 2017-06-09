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
        
        var type: UInt8 {
            switch self {
            case .move(_):
                return 0
            case .addLine(_):
                return 1
            case .addCurve(_):
                return 2
            case .close:
                return 3
            case .fill(_):
                return 4
            case .stroke(_):
                return 5
            case .setLineWidth(_):
                return 6
            case .usesEvenOddFillRule:
                return 7
            case .initWith(_):
                return 8
            case .initWith2(_):
                return 9
            case .initWith3(_):
                return 10                
            }
        }
    }
}
