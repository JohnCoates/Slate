//
//  Writer.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

class VectorAssetWriter {
    
    let sourceCanvases: [Canvas]
    let sourceInstructions: [Path.Instruction]
    
    lazy var floats: [DataFloat] = self.dataFloats()
    lazy var colors: [DataColor] = self.allColors()
    lazy var sections: [String] = self.allSections()
    lazy var canvases: [DataCanvas] = self.dataCanvases()
    
    init(canvases: [Canvas]) {
        sourceCanvases = canvases
        sourceInstructions = VectorAssetWriter.allInstructions(fromCanvases: canvases)
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
