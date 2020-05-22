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
    class func generateQuad(forDevice device: MTLDevice, inArray vertices: inout [Vertex],
                            inputSize: Size? = nil, targetSize: Size? = nil) -> MTLBuffer {
        vertices.removeAll()
        if let inputSize = inputSize, let targetSize = targetSize {
            print("got input size!")
            vertices += Vertices.quadForAspectFill(input: inputSize, target: targetSize)
        } else {
            vertices += Vertices.fullScreenQuad()
        }
        
        var options: MTLResourceOptions = []
        #if os(macOS)
            options = [.storageModeManaged]
        #endif
        
        return device.makeBuffer(bytes: vertices,
                                 length: MemoryLayout<Vertex>.stride * vertices.count,
                                 options: options)!
    }
    
    class func generate(textureCoordinates coordinates: inout[SIMD2<Float>], forDevice device: MTLDevice) -> MTLBuffer {
        
        var options: MTLResourceOptions = []
        #if os(macOS)
            coordinates += TextureCoordinates.macFlipped()
            options = [.storageModeManaged]
        #endif
        
        #if os(iOS)
            coordinates += TextureCoordinates.iOSDevicePortrait()
        #endif
        
        return device.makeBuffer(bytes: coordinates,
                                 length: MemoryLayout<SIMD2<Float>>.stride * coordinates.count,
                                 options: options)!
    }
    
    // MARK: - Buffer Updates
    
    #if os(macOS)
    
    func invalidateVertexBuffer() {
        let contents = vertexBuffer.contents()
        memcpy(contents, vertices, MemoryLayout<Vertex>.stride * vertices.count)
        let length = vertexBuffer.length
        vertexBuffer.didModifyRange(0..<length)
    }
    
    func invalidateTextureCoordinatesBuffer() {
        let contents = textureCoordinatesBuffer.contents()
        memcpy(contents, textureCoordinates, MemoryLayout<SIMD2<Float>>.stride * textureCoordinates.count)
        let length = textureCoordinatesBuffer.length
        textureCoordinatesBuffer.didModifyRange(0..<length)
    }
    
    #endif
    
    func updateVertices(withViewSize viewSize: CGSize) {
        guard let inputSize = cameraController.inputSize else {
            print("Couldn't get camera input size!")
            return
        }
        let targetSize = Size(viewSize)
        #if os(iOS)
            // Switch width with height because camera input is flipped
            let inputSwitched = Size(width: inputSize.height, height: inputSize.width)
            verticesUpdate = Vertices.quadForAspectFill(input: inputSwitched, target: targetSize)
        #else
//            verticesUpdate = Vertices.quadForAspectFill(input: inputSize, target: targetSize)
            verticesUpdate = Vertices.quadForAspectFill(input: inputSize, target: targetSize)
            
        #endif
    }
    
    func updateTextureCoordinates(withViewSize viewSize: CGSize) {
        guard let inputSize = cameraController.inputSize else {
            print("Couldn't get camera input size!")
            return
        }
        let targetSize = Size(viewSize)
        #if os(iOS)
            // Switch width with height because camera input is flipped
            let inputSwitched = Size(width: inputSize.height, height: inputSize.width)
            textureCoordinatesUpdate = TextureCoordinates.quadForAspectFill(input: inputSwitched,
                                                                            target: targetSize)
        #else
            textureCoordinatesUpdate = TextureCoordinates.quadForAspectFill(input: inputSize,
                                                                            target: targetSize)
        #endif
    }
    
    // MARK: - Command Buffer Boundary Functions
    // For iOS buffer updates which have shared storage mode
    // Resource coherency is only guaranteed at command buffer boundaries.
    // https://developer.apple.com/reference/metal/mtlstoragemode/1515989-shared
    
    func replaceWhileOutsideOfCommandBufferBoundary(vertices newVertices: [Vertex]) {
        guard newVertices.count == vertices.count else {
            fatalError("Can't update vertices with different amount of items")
        }
        let contents = vertexBuffer.contents()
        memcpy(contents, newVertices, MemoryLayout<Vertex>.stride * vertices.count)
        #if os(macOS)
            vertexBuffer.didModifyRange(0..<vertexBuffer.length)
        #endif
    }
    
    func replaceWhileOutsideOfCommandBufferBoundary(textureCoordinates newTextureCoordinates: [SIMD2<Float>]) {
        guard newTextureCoordinates.count == textureCoordinates.count else {
            fatalError("Can't update texture coordinates with different amount of items")
        }
        let contents = textureCoordinatesBuffer.contents()
        memcpy(contents, newTextureCoordinates, MemoryLayout<SIMD2<Float>>.stride * textureCoordinates.count)
        #if os(macOS)
            textureCoordinatesBuffer.didModifyRange(0..<textureCoordinatesBuffer.length)
        #endif
    }
    
}
