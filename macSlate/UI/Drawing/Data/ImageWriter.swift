//
//  ImageWriter.swift
//  Slate
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

class ImageWriter {
    static var format: UInt8 = 1
    
    let _canvases: [Canvas]
    let _instructions: [Instruction]
    
    lazy var floats: [DataFloat] = self.dataFloats()
    lazy var colors: [DataColor] = self.allColors()
    lazy var sections: [String] = self.allSections()
    lazy var canvases: [DataCanvas] = self.dataCanvases()
    
    init(canvases: [Canvas]) {
        _canvases = canvases
        _instructions = ImageWriter.allInstructions(fromCanvases: canvases)
    }
    
    var data = Data()
    func write() {
        addHeader()
        addFloats()
        addColors()
        addSections()
        addCanvases()
        
        let writeTo = URL(fileURLWithPath: "/tmp/image.vif")
        do {
            try data.write(to: writeTo, options: .atomic)
        } catch let error {
            print("error: \(error)")
        }
    }
    
    func addHeader() {
        data.append(&ImageWriter.format, count: 1)
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
    
    func append(point: DataPoint) {
        append(uInt16: point.xIndex)
        append(uInt16: point.yIndex)
    }
    func append(nullTerminatedString string: String) {
        let value = string.cString(using: .utf8)
        let bytes = string.lengthOfBytes(using: .utf8) + 1
        print("appending string with bytes: \(bytes)")
        data.append(UnsafeBufferPointer(start: value, count: bytes))
    }
    func append(uInt8 constValue: UInt8) {
        var value = constValue
        data.append(UnsafeBufferPointer(start: &value, count: 1))
    }
    func append(uInt16 constValue: UInt16) {
        var value = constValue
        data.append(UnsafeBufferPointer(start: &value, count: 1))
    }
    
    typealias Instruction = Path.Instruction
    typealias Color = Path.Color
    
    static func allInstructions(fromCanvases canvases: [Canvas]) -> [Instruction] {
        let paths: [Path] = canvases.reduce([Path]()) { list, canvas in
            let newList = list + canvas.paths
            return newList
        }
        let instructions = paths.reduce([Instruction]()) { list, path in
            let newList = list + path.instructions
            return newList
        }
        return instructions
    }
    
    func dataFloats() -> [DataFloat] {
        var floats = [Float]()
        for instruction in _instructions {
            switch instruction {
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
                add(floats:[to], toFloats: &floats)
            case .close, .usesEvenOddFillRule:
                break
            }
        }
        
        for canvas in _canvases {
            add(floats:[canvas.width, canvas.height], toFloats: &floats)
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
        var colors = [Color]()
        
        for instruction in _instructions {
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
    
    func allSections() -> [String] {
        var sections = [String]()
        for canvas in _canvases {
            if !sections.contains(canvas.section) {
                sections.append(canvas.section)
            }
        }
        
        return sections
    }
    func dataCanvases() -> [DataCanvas] {
        return _canvases.map { canvas -> DataCanvas in
            
            let paths = dataPaths(fromPaths: canvas.paths, floats: floats, colors: colors)
            
            let dataCanvas = DataCanvas(name: canvas.name,
                                        sectionIndex: sectionIndex(forSection: canvas.section),
                                        widthIndex: index(forFloat: canvas.width),
                                        heightIndex: index(forFloat: canvas.height),
                                        paths: paths
                                        )
            
            return dataCanvas
        }
    }
    
    func sectionIndex(forSection section: String) -> UInt16 {
        guard let index = sections.index(of: section) else {
            fatalError("Couldn't find section \(section) in sections: \(sections)")
        }
        return UInt16(index)
    }
    
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
        for dataColor in colors {
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
        let red = floats[Int(dataColor.redIndex)].value
        let green = floats[Int(dataColor.redIndex)].value
        let blue = floats[Int(dataColor.redIndex)].value
        let alpha = floats[Int(dataColor.redIndex)].value
        
        return Path.Color(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func index(forFloat float: Float) -> UInt16 {
        guard let index = floats.index(where: { $0.value == float }) else {
            fatalError("Couldn't find float value: \(float) in \(floats)!")
        }
        let value = floats[index]
        return value.index
    }
    
    func add(point: Path.Point, toFloats floats: inout [Float]) {
        add(floats: [point.x, point.y], toFloats: &floats)
    }
    
    func add(color: Color, toFloats floats: inout [Float]) {
        add(floats: [color.red, color.green, color.blue, color.alpha], toFloats: &floats)
    }
    
    func add(floats inFloats: [Float], toFloats floats: inout [Float]) {
        for float in inFloats {
            if !floats.contains(float) {
                floats.append(float)
            }
        }
    }
}

struct DataColor {
    let redIndex: UInt16
    let greenIndex: UInt16
    let blueIndex: UInt16
    let alphaIndex: UInt16
    let index: UInt16
}

struct DataPoint {
    let xIndex: UInt16
    let yIndex: UInt16
}

struct DataCanvas {
    let name: String
    let sectionIndex: UInt16
    let widthIndex: UInt16
    let heightIndex: UInt16
    let paths: [DataPath]
}

struct DataPath {
    let instructions: [DataInstruction]
}

enum DataInstruction {
    case move(to: DataPoint)
    case addLine(to: DataPoint)
    case addCurve(to: DataPoint, control1: DataPoint, control2: DataPoint)
    case close
    case fill(color: DataColor)
    case stroke(color: DataColor)
    case setLineWidth(toFloatIndex: UInt16)
    case usesEvenOddFillRule
    
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
            
        }
    }
}

struct DataFloat: CustomStringConvertible, Equatable {
    let value: Float
    let index: UInt16
    
    var description: String {
        return "[DataFloat \(value), index: \(index)]"
    }
}

// MARK: - Colors

func == (lhs: DataFloat, rhs: DataFloat) -> Bool {
    return lhs.value == rhs.value
}

func == (lhs: Float, rhs: DataFloat) -> Bool {
    return lhs == rhs.value
}
