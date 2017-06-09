//
//  Writer.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension VectorImage {
    
    class Writer {
        typealias DataColor = VectorImage.DataColor
        typealias DataPath = VectorImage.DataPath
        typealias DataPoint = VectorImage.DataPoint
        typealias DataRect = VectorImage.DataRect
        typealias DataCanvas = VectorImage.DataCanvas
        typealias DataInstruction = VectorImage.DataInstruction
        typealias Instruction = Path.Instruction
        typealias Color = Path.Color
        typealias Writer = VectorImage.Writer
        
        static let format: UInt8 = 1
        
        let _canvases: [Canvas]
        let _instructions: [Instruction]
        
        lazy var floats: [DataFloat] = self.dataFloats()
        lazy var colors: [DataColor] = self.allColors()
        lazy var sections: [String] = self.allSections()
        lazy var canvases: [DataCanvas] = self.dataCanvases()
        
        init(canvases: [Canvas]) {
            _canvases = canvases
            _instructions = Writer.allInstructions(fromCanvases: canvases)
        }
        
        var data = Data()
        func write() {
            addHeader()
            addFloats()
            addColors()
            addSections()
            addCanvases()
            
            writeToFile()
            writeCompressedToFile()
        }
    }
}
