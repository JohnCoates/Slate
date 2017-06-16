//
//  Writer+Generators.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity

import Foundation

extension VectorAssetWriter {
    
    func dataFloats() -> [DataFloat] {
        var floats = [Float]()
        let instructions: [Path.Instruction] = sourceInstructions
        for instruction in instructions {
            switch instruction {
            case .initWith(let rect), .initWith3(let rect):
                add(point: rect.origin, toFloats: &floats)
                add(point: rect.size, toFloats: &floats)
            case .initWith2(let rect, let cornerRadius):
                add(point: rect.origin, toFloats: &floats)
                add(point: rect.size, toFloats: &floats)
                add(floats: [cornerRadius], toFloats: &floats)
            case .move(let to), .addLine(let to):
                add(point: to, toFloats: &floats)
                break
            case .addCurve(let to, let control1, let control2):
                add(point: to, toFloats: &floats)
                add(point: control1, toFloats: &floats)
                add(point: control2, toFloats: &floats)
            case .fill(let color), .stroke(let color):
                add(color: color, toFloats: &floats)
            case .setLineWidth(let to):
                add(floats: [to], toFloats: &floats)
            case .close, .usesEvenOddFillRule, .setLineCapStyle(_):
                break
            // graphics context
            case .contextSaveGState, .contextRestoreGState:
                break
            case .contextTranslateBy(let x, let y):
                add(floats: [x, y], toFloats: &floats)
            case .contextRotate(let by):
                add(floats: [by], toFloats: &floats)
            }
        }
        
        for canvas in sourceCanvases {
            add(floats: [canvas.width, canvas.height], toFloats: &floats)
        }
        
        var index: UInt16 = 0
        let dataFloats = floats.map { float -> DataFloat in
            let value = DataFloat(value: float, index: index)
            index += 1
            return value
        }
        return dataFloats
    }
    
    func allColors() -> [DataColor] {
        var colors: [Path.Color] = Array()
        
        for instruction in sourceInstructions {
            switch instruction {
            case .fill(let color), .stroke(let color):
                if !colors.contains(color) {
                    colors.append(color)
                }
            default:
                break
            }
        }
        
        var currentIndex: UInt16 = 0
        let dataColors = colors.map { color -> DataColor in
            let value = DataColor(redIndex: index(forFloat: color.red),
                                  greenIndex: index(forFloat: color.green),
                                  blueIndex: index(forFloat: color.blue),
                                  alphaIndex: index(forFloat: color.alpha),
                                  index: currentIndex)
            currentIndex += 1
            return value
        }
        
        return dataColors
    }
    
    func dataCanvases() -> [DataCanvas] {
        return sourceCanvases.map { canvas -> DataCanvas in
            
            let paths = dataPaths(fromPaths: canvas.paths, floats: floats, colors: colors)
            let instructions = canvas.instructions.map { dataInstruction(fromInstruction: $0) }
            
            let dataCanvas = DataCanvas(name: canvas.name,
                                        sectionIndex: sectionIndex(forSection: canvas.section),
                                        widthIndex: index(forFloat: canvas.width),
                                        heightIndex: index(forFloat: canvas.height),
                                        instructions: instructions,
                                        paths: paths
            )
            
            return dataCanvas
        }
    }
    
    static func allInstructions(fromCanvases canvases: [Canvas]) -> [Path.Instruction] {
        let paths: [Path] = canvases.reduce([Path]()) { list, canvas in
            let newList = list + canvas.paths
            return newList
        }
        let instructions: [Path.Instruction] = paths.reduce(Array()) { list, path in
            let newList = list + path.instructions
            return newList
        }
        
        let canvasInstructions: [Path.Instruction] = canvases.reduce(Array()) { list, canvas in
            let newList = list + canvas.instructions
            return newList
        }
        return instructions + canvasInstructions
    }    
    
    func allSections() -> [String] {
        var sections = [String]()
        for canvas in sourceCanvases {
            if !sections.contains(canvas.section) {
                sections.append(canvas.section)
            }
        }
        
        return sections
    }
    
}
