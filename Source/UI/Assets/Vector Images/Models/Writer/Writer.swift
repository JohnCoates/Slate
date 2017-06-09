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
        func write(toFile: URL, compressed: Bool = false) {
            addHeader()
            addFloats()
            addColors()
            addSections()
            addCanvases()
            
            if compressed {
                writeCompressed(toFile: toFile)
            } else {
                write(toFile: toFile)
            }
            
        }
        
        // MARK: - File Handling
        
        private func write(toFile filePath: URL) {
            do {
                try data.write(to: filePath, options: .atomic)
            } catch let error {
                print("error: \(error)")
            }
        }
        
        private func writeCompressed(toFile filePath: URL) {
            do {
                let compressed = try data.compress(withAlgorithm: VectorImage.compressionAlgorithm)
                print("compressed size: \(compressed.count), original: \(data.count)")
                try compressed.write(to: filePath, options: .atomic)
            } catch let error {
                print("Compression error: \(error)")
            }
            
        }
    }
}
