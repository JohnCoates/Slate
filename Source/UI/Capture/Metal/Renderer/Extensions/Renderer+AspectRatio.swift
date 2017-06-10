//
//  Renderer+AspectRatio.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Metal
import MetalKit

extension Renderer {

    // MARK: - Resizing

    #if os(macOS)
    
    func setAspectRatio(width: Float, height: Float) {
        guard let inputSize = cameraController.inputSize else {
            print("Missing input aspect ratio")
            return
        }
        let targetSize = Size(width: width, height: height)
        
        vertices.removeAll()
        vertices += Vertices.quadForAspectFill(input: inputSize,
                                               target: targetSize)
        
        invalidateVertexBuffer()
    }
    
    #endif
}
