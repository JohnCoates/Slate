//
//  Writer+Conversions.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension VectorImage.Writer {

    func dataPaths(fromPaths path: [Path], floats: [DataFloat], colors: [DataColor]) -> [DataPath] {
        return path.map { path -> DataPath in
            let instructions = path.instructions.map({ dataInstruction(fromInstruction: $0) })
            return DataPath(instructions: instructions)
        }
    }

    
    func dataInstruction(fromInstruction instruction: Path.Instruction) -> DataInstruction {
        switch instruction {
        case .move(let point):
            return DataInstruction.move(to: dataPoint(fromPoint: point))
        case .addLine(let point):
            return DataInstruction.addLine(to: dataPoint(fromPoint: point))
        case .addCurve(let to, let control1, let control2):
            return DataInstruction.addCurve(to: dataPoint(fromPoint: to),
                                            control1: dataPoint(fromPoint: control1),
                                            control2: dataPoint(fromPoint: control2))
        case .close:
            return DataInstruction.close
        case .fill(let color):
            return DataInstruction.fill(color: dataColor(fromColor: color))
        case .stroke(let color):
            return DataInstruction.stroke(color: dataColor(fromColor: color))
        case .setLineWidth(let to):
            return DataInstruction.setLineWidth(toFloatIndex: index(forFloat: to))
        case .usesEvenOddFillRule:
            return DataInstruction.usesEvenOddFillRule
        }
    }
    
    func dataColor(fromColor color: Color) -> DataColor {
        for dataColor in self.colors {
            let realColor = self.color(fromDataColor: dataColor)
            if realColor == color {
                return dataColor
            }
        }
        fatalError("Couldn't find color: \(color)")
    }
    
    func dataPoint(fromPoint point: Path.Point) -> DataPoint {
        return DataPoint(xIndex: index(forFloat: point.x),
                         yIndex: index(forFloat: point.y))
    }
    
    func color(fromDataColor dataColor: DataColor) -> Path.Color {
        let red = self.floats[Int(dataColor.redIndex)].value
        let green = self.floats[Int(dataColor.redIndex)].value
        let blue = self.floats[Int(dataColor.redIndex)].value
        let alpha = self.floats[Int(dataColor.redIndex)].value
        
        return Path.Color(red: red, green: green, blue: blue, alpha: alpha)
    }
}
