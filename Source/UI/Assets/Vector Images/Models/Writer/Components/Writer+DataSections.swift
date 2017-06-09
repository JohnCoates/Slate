//
//  Writer+DataSections.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension VectorImage.Writer {
    
    func addHeader() {
        append(uInt8: Writer.format)
    }
    
    func addFloats() {
        let max = Int(UInt16.max)
        guard floats.count < max else {
            fatalError("There are \(floats.count), but we can only store \(max)")
        }
        
        append(uInt16: UInt16(floats.count))
        print("floats: \(floats.count)")
        
        for float in floats {
            var value: Float = float.value
            data.append(UnsafeBufferPointer(start: &value, count: 1))
        }
    }
    
    func addColors() {
        let max = Int(UInt16.max)
        guard colors.count < max else {
            fatalError("There are \(colors.count) colors, but we can only store \(max)")
        }
        append(uInt16: UInt16(colors.count))
        
        for color in colors {
            append(uInt16: color.redIndex)
            append(uInt16: color.greenIndex)
            append(uInt16: color.blueIndex)
            append(uInt16: color.alphaIndex)
        }
    }
    
    func addSections() {
        let max = UInt16.max
        guard sections.count < Int(max) else {
            fatalError("There are \(sections.count) sections, but we can only store \(max)")
        }
        append(uInt16: UInt16(sections.count))
        
        for section in sections {
            append(nullTerminatedString: section)
        }
    }
    
    func addCanvases() {
        let max = UInt16.max
        guard canvases.count < Int(max) else {
            fatalError("There are \(canvases.count) canvases, but we can only store \(max)")
        }
        append(uInt16: UInt16(canvases.count))
        
        for canvas in canvases {
            print("adding canvas \(canvas.name)")
            append(nullTerminatedString: canvas.name)
            append(uInt16: canvas.sectionIndex)
            append(uInt16: canvas.widthIndex)
            append(uInt16: canvas.heightIndex)
            
            add(paths: canvas.paths)
        }
    }
    
    func add(paths: [DataPath]) {
        let max = UInt16.max
        guard paths.count < Int(max) else {
            fatalError("There are \(paths.count) paths, but we can only store \(max)")
        }
        append(uInt16: UInt16(paths.count))
        
        for path in paths {
            add(instructions: path.instructions)
        }
    }
    
    func add(instructions: [DataInstruction]) {
        let max = UInt16.max
        guard instructions.count < Int(max) else {
            fatalError("There are \(instructions.count) instructions, but we can only store \(max)")
        }
        append(uInt16: UInt16(instructions.count))
        
        for instruction in instructions {
            append(uInt8: instruction.type)
            switch instruction {
            case .move(let point), .addLine(let point):
                append(point: point)
            case .addCurve(let to, let control1, let control2):
                append(point: to)
                append(point: control1)
                append(point: control2)
            case .fill(let color), .stroke(let color):
                append(uInt16: color.index)
            case .setLineWidth(let floatIndex):
                append(uInt16: floatIndex)
            case .close, .usesEvenOddFillRule:
                break
            }
        }
    }
}
