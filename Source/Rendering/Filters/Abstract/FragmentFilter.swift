//
//  AbstractFragmentFilter.swift
//  Slate
//
//  Created by John Coates on 10/13/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import MetalKit

class FragmentFilter: AbstractFilter {
    var vertexBuffer: MTLBuffer
    var textureCoordinatesBuffer: MTLBuffer
    var vertices = [Vertex]()
    var textureCoordinates = [float2]()
    
    override init(device: MTLDevice) {
        vertexBuffer = Renderer.generateQuad(forDevice: device, inArray: &vertices)
        textureCoordinatesBuffer = Renderer.generate(textureCoordinates: &textureCoordinates,
                                                     forDevice: device)
        super.init(device: device)
    }
    
    var renderPipelineState: MTLRenderPipelineState!
    func buildRenderPipeline(label: String,
                             vertexFunction vertexFunctionName: String,
                             fragmentFunction fragmentFunctionName: String) {
        guard let library = device.newDefaultLibrary() else {
            fatalError("Couldn't find shader libary")
        }
        
        // Retrieve the functions that will comprise our pipeline
        guard let vertexFunction = library.makeFunction(name: vertexFunctionName),
            let fragmentFunction = library.makeFunction(name: fragmentFunctionName) else {
                fatalError("Couldn't get shader functions")
        }
        
        // A render pipeline descriptor describes the configuration of our programmable pipeline
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.label = label
        pipelineDescriptor.sampleCount = 1
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        //      pipelineDescriptor.depthAttachmentPixelFormat = view.depthStencilPixelFormat
        
        // compile intermediate shaders into hardward-optimized code
        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Couldn't build render pipeline state: \(error)")
        }
    }
    
    func renderToOutputTexture(commandBuffer: MTLCommandBuffer, inputTexture: MTLTexture) -> MTLTexture {
        let outputTexture = self.outputTexture(forInputTexture: inputTexture)
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1)
        renderPassDescriptor.colorAttachments[0].loadAction = .load
        renderPassDescriptor.colorAttachments[0].storeAction = .dontCare
        renderPassDescriptor.colorAttachments[0].texture = outputTexture
        
        // Create a render encoder to clear the screen and draw our objects
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        renderEncoder.pushDebugGroup("Chromatic Aberration")
        // Set the pipeline state so the GPU knows which vertex and fragment function to invoke.
        renderEncoder.setRenderPipelineState(renderPipelineState)
        renderEncoder.setFrontFacing(.counterClockwise)
        
        // Bind the buffer containing the array of vertex structures so we can
        // read it in our vertex shader.
        renderEncoder.setVertexBuffer(vertexBuffer, offset:0, at:0)
        renderEncoder.setVertexBuffer(textureCoordinatesBuffer, offset: 0, at: 1)
        renderEncoder.setFragmentTexture(inputTexture, at: 0)
        renderEncoder.drawPrimitives(type: .triangle,
                                     vertexStart: 0,
                                     vertexCount: 6,
                                     instanceCount: 1)
        renderEncoder.popDebugGroup()
        
        // We are finished with this render command encoder, so end it.
        renderEncoder.endEncoding()
        return outputTexture
    }
}
