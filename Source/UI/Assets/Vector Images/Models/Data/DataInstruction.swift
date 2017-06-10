//
//  Instruction.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable nesting

import Foundation

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
    
    // Graphics Context
    case contextSaveGState
    case contextRestoreGState
    case contextTranslateBy(xIndex: UInt16, yIndex: UInt16)
    case contextRotate(byIndex: UInt16)
    
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
        case contextSaveGState = 11
        case contextRestoreGState = 12
        case contextTranslateBy = 13
        case contextRotate = 14
    }
    
    var type: UInt8 {
        return kind.rawValue
    }
    
    var kind: Kind {
        switch self {
        case .move(_):
            return .move
        case .addLine(_):
            return .addLine
        case .addCurve(_):
            return .addCurve
        case .close:
            return .close
        case .fill(_):
            return .fill
        case .stroke(_):
            return .stroke
        case .setLineWidth(_):
            return .setLineWidth
        case .usesEvenOddFillRule:
            return .usesEvenOddFillRule
        case .initWith(_):
            return .initWith
        case .initWith2(_):
            return .initWith2
        case .initWith3(_):
            return .initWith3
        case .contextSaveGState:
            return .contextSaveGState
        case .contextRestoreGState:
            return .contextRestoreGState
        case .contextTranslateBy(_):
            return .contextTranslateBy
        case .contextRotate(_):
            return .contextRotate            
        }
    }
}
