//
//  VectorAssetReader
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity function_body_length

import UIKit

class VectorAssetReader {
    enum Error: Swift.Error {
        case wrongFormat(expected: UInt8, fileFormat: UInt8)
    }
    
    let data: Data
    
    init(file: URL) throws {
        let fileExtension = file.pathExtension
        var compressed: Bool = false
        switch fileExtension {
        case "vif":
            break
        case "cvif":
            compressed = true
        default:
            fatalError("File has wrong type of extension")
        }
        
        let data = try Data(contentsOf: file)
        if compressed {
            self.data = try data.decompress(withAlgorithm: VectorImage.compressionAlgorithm)
        } else {
            self.data = data
        }
    }
    
    var readIndex: Int = 0
    
    func read() throws {
        readIndex = 0
        
        let format = readUInt8()
        if format != VectorImage.format {
            throw Error.wrongFormat(expected: VectorImage.format, fileFormat: format)
        }
        
        readFloats()
        readColors()
        readSections()
        readCanvases()
    }
    
    var floats = [Float]()
    
    func readFloats() {
        let count = readUInt16()
        var floats = [Float]()
        for _ in 0..<count {
            let float = readFloat()
            floats.append(float)
        }
        
        self.floats = floats
    }
    
    private var colors = [DataColor]()
    
    func readColors() {
        let count = readUInt16()
        var colors = [DataColor]()
        for index in 0..<count {
            let color = DataColor(redIndex: readUInt16(),
                                  greenIndex: readUInt16(),
                                  blueIndex: readUInt16(),
                                  alphaIndex: readUInt16(),
                                  index: index)
            colors.append(color)
        }
        
        self.colors = colors
    }    
    
    var sections = [String]()
    
    func readSections() {
        let count = readUInt16()
        var sections = [String]()
        for _ in 0..<count {
            let section = readString()
            sections.append(section)
        }
        self.sections = sections
    }
    
    var canvases = [Canvas]()
    
    func readCanvases() {
        let count = readUInt16()
        
        var canvases = [Canvas]()
        for _ in 0..<count {
            let name = readString()
            let sectionIndex = Int(readUInt16())
            let section = sections[sectionIndex]
            let width = readIndexFloat()
            let height = readIndexFloat()
            
            let canvas = Canvas(name: name, section: section, width: width, height: height)
            canvas.instructions = readInstructions()
            canvas.paths = readPaths()
            canvases.append(canvas)
        }
        
        self.canvases = canvases
    }
    
    func readPaths() -> [Path] {
        let count = readUInt16()
        
        var paths = [Path]()
        for _ in 0..<count {
            let path = Path()
            path.instructions = readInstructions()
            paths.append(path)
        }
        return paths
    }
    
    func readInstructions() -> [Path.Instruction] {
        let count = readUInt16()
        
        var instructions: [Path.Instruction] = Array()
        for _ in 0..<count {
            let rawKind = readUInt8()
            guard let kind = DataInstruction.Kind(rawValue: rawKind) else {
                fatalError("Invalid instruction kind: \(rawKind)")
            }
            let instruction: Path.Instruction
            switch kind {
            case .move:
                instruction = .move(to: readPoint())
            case .addLine:
                instruction = .addLine(to: readPoint())
            case .addCurve:
                instruction = .addCurve(to: readPoint(),
                                        control1: readPoint(),
                                        control2: readPoint())
            case .close:
                instruction = .close
            case .fill:
                instruction = .fill(color: readColor())
            case .stroke:
                instruction = .stroke(color: readColor())
            case .setLineWidth:
                instruction = .setLineWidth(to: readIndexFloat())
            case .setLineCapStyle:
                let rawLineCapStyle = readUInt8()
                guard let lineCapStyle = Path.LineCapStyle(rawValue: rawLineCapStyle) else {
                    fatalError("Invalid line cap style: \(rawLineCapStyle)")
                }
                instruction = .setLineCapStyle(to: lineCapStyle)
            case .usesEvenOddFillRule:
                instruction = .usesEvenOddFillRule
            case .initWith:
                instruction = .initWith(rect: readRect())
            case .initWith2:
                instruction = .initWith2(rect: readRect(), cornerRadius: readIndexFloat())
            case .initWith3:
                instruction = .initWith3(ovalIn: readRect())
            // Graphics Context
            case .contextSaveGState:
                instruction = .contextSaveGState
            case .contextRestoreGState:
                instruction = .contextRestoreGState
            case .contextTranslateBy:
                instruction = .contextTranslateBy(x: readIndexFloat(), y: readIndexFloat())
            case .contextRotate:
                instruction = .contextRotate(by: readIndexFloat())
            }
            instructions.append(instruction)
        }
        return instructions
    }
    
    // MARK: - Read Utilities
    
    func readIndexFloat() -> Float {
        let floatIndex = Int(readUInt16())
        return floats[floatIndex]
    }
    
    func readColor() -> Path.Color {
        let colorIndex = Int(readUInt16())
        let indexedColor = colors[colorIndex]
        return Path.Color(red: floats[Int(indexedColor.redIndex)],
                          green: floats[Int(indexedColor.greenIndex)],
                          blue: floats[Int(indexedColor.blueIndex)],
                          alpha: floats[Int(indexedColor.alphaIndex)])
    }
    
    func readRect() -> Path.Rect {
        let x = readIndexFloat()
        let y = readIndexFloat()
        let width = readIndexFloat()
        let height = readIndexFloat()
        let origin = Path.Point(x: x, y: y)
        let size = Path.Point(x: width, y: height)
        return Path.Rect(origin: origin, size: size)
    }
    
    func readPoint() -> Path.Point {
        let xIndex = Int(readUInt16())
        let yIndex = Int(readUInt16())
        return Path.Point(x: floats[xIndex], y: floats[yIndex])
    }
    
    func readString() -> String {
        let startIndex = readIndex
        var endIndex = readIndex
        while readUInt8() != 0 {
            endIndex = readIndex
            continue
        }
        
        guard let value = String(data: data.subdata(in: startIndex..<endIndex), encoding: .utf8) else {
            fatalError("Invalid string!")
        }
        
        return value
    }
    
    func readUInt8() -> UInt8 {
        return readValue()
    }
    
    func readUInt16() -> UInt16 {
        return readValue()
    }
    
    func readFloat() -> Float {
        return readValue()
    }
    
    func readValue<T>() -> T {
        let size = MemoryLayout<T>.size
        let value: T = data.subdata(in: readIndex..<readIndex + size).withUnsafeBytes { $0.pointee }
        readIndex += size
        return value
    }
    
}
