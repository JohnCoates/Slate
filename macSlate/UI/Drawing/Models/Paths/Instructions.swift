//
//  Instructions.swift
//  Slate
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension Path {
    enum Instruction {
        case move(to: Point)
        case addLine(to: Point)
        case addCurve(to: Point, control1: Point, control2: Point)
        case close
        case fill(color: Color)
        case stroke(color: Color)
        case setLineWidth(to: Float)
        case usesEvenOddFillRule
    }
    
    struct Point {
        let x: Float
        let y: Float
    }
    
    struct Color: Equatable {
        let red: Float
        let green: Float
        let blue: Float
        let alpha: Float
    }
}

func == (lhs: Path.Color, rhs: Path.Color) -> Bool {
    if lhs.red   == rhs.red,
       lhs.green == rhs.green,
       lhs.blue  == rhs.blue,
       lhs.alpha == rhs.alpha {
        return true
    } else {
        return false
    }
}
