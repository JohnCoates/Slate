//
//  Renderer+Buffers.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Metal
import MetalKit

extension Renderer {
    
    // MARK: - Generating
    
    // developer.apple.com/library/content/documentation/Miscellaneous/
    // Conceptual/MetalProgrammingGuide/Render-Ctx/Render-Ctx.html
    
    // Metal defines its Normalized Device Coordinate (NDC) system as a 2x2x1 cube with its center a
    // (0, 0, 0.5). The left and bottom for x and y, respectively, of the NDC system are specified as -1.
    // The right and top for x and y, respectively, of the NDC system are specified as +1.
    class func generateQuad(forDevice device: MTLDevice, inArray vertices: inout [Vertex]) -> MTLBuffer {
        vertices.removeAll()
        vertices += Vertices.quad()
        
        var options: MTLResourceOptions = []
        #if os(macOS)
            options = [.storageModeManaged]
        #endif
        
        return device.makeBuffer(bytes: vertices,
                                 length: MemoryLayout<Vertex>.stride * vertices.count,
                                 options: options)
    }
    
    class func generate(textureCoordinates coordinates: inout[float2], forDevice device: MTLDevice) -> MTLBuffer {
        
        var options: MTLResourceOptions = []
        #if os(macOS)
            coordinates += TextureCoordinates.macFlipped()
            options = [.storageModeManaged]
        #endif
        
        #if os(iOS)
            coordinates += TextureCoordinates.devicePortrait()
        #endif
        
        return device.makeBuffer(bytes: coordinates,
                                 length: MemoryLayout<float2>.stride * coordinates.count,
                                 options: options)
    }
    
    // MARK: - Buffer Updates
    
    #if os(macOS)
    func invalidateVertexBuffer() {
        let contents = vertexBuffer.contents()
        memcpy(contents, vertices, MemoryLayout<Vertex>.stride * vertices.count)
        let length = vertexBuffer.length
        let range = NSRange(location: 0, length: length)
        vertexBuffer.didModifyRange(range)
    }
    
    func invalidateTextureCoordinatesBuffer() {
        let contents = textureCoordinatesBuffer.contents()
        memcpy(contents, textureCoordinates, MemoryLayout<float2>.stride * textureCoordinates.count)
        let length = textureCoordinatesBuffer.length
        let range = NSRange(location: 0, length: length)
        textureCoordinatesBuffer.didModifyRange(range)
    }
    #endif
}
