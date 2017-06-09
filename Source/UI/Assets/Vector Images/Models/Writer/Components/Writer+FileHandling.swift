//
//  Writer+FileHandling.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension VectorImage.Writer {
    func writeToFile() {
        let writeTo = URL(fileURLWithPath: "/tmp/image.vif")
        do {
            try data.write(to: writeTo, options: .atomic)
        } catch let error {
            print("error: \(error)")
        }
    }
    
    func writeCompressedToFile() {
        do {
            let compressed = try data.compress(withAlgorithm: .lzma)
            print("compressed size: \(compressed.count), original: \(data.count)")
        } catch let error {
            print("Compression error: \(error)")
        }
        
    }
}
