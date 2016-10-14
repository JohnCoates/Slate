//
//  ChromaticAberrationFilter.swift
//  Slate
//
//  Created by John Coates on 10/2/16.
//  Copyright © 2016 John Coates. All rights reserved.
//
// reference
// https://developer.apple.com/library/content/documentation/Miscellaneous/Conceptual/MetalProgrammingGuide/
// Compute-Ctx/Compute-Ctx.html

import Foundation
import MetalKit

final class ChromaticAberrationFragmentFilter: FragmentFilter {
    
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
    func buildRenderPipeline() {
        guard let library = device.newDefaultLibrary() else {
            fatalError("Couldn't find shader libary")
        }
        
        // Retrieve the functions that will comprise our pipeline
        guard let vertexFunction = library.makeFunction(name: "vertexPassthrough"),
            let fragmentFunction = library.makeFunction(name: "chromaticAberrationFragment") else {
            fatalError("Couldn't get shader functions")
        }
        
        // A render pipeline descriptor describes the configuration of our programmable pipeline
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.label = "Chromatic Aberration Pipeline"
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
    
    // MARK: - Textures
    
    fileprivate var outputTexture: MTLTexture?
    func outputTexture(forInputTexture inputTexture: MTLTexture) -> MTLTexture {
        if let outputTexture = outputTexture {
            if outputTexture.width == inputTexture.width, outputTexture.height == inputTexture.height {
                return outputTexture
            }
            
        }
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                  width: inputTexture.width,
                                                                  height: inputTexture.height,
                                                                  mipmapped: false)
        descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        let texture = device.makeTexture(descriptor: descriptor)
        outputTexture = texture
        return texture
    }
    
    override func filter(withCommandBuffer commandBuffer: MTLCommandBuffer,
                         inputTexture: MTLTexture) -> MTLTexture {
        if renderPipelineState == nil {
            buildRenderPipeline()
        }
        let outputTexture = self.outputTexture(forInputTexture: inputTexture)
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1)
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
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

final class ChromaticAberrationFilter: ComputeFilter {
    
    var pipelineState: MTLComputePipelineState!
    override func buildPipeline() {
        let shaderName = "chromaticAberrationCompute"
        guard let library = device.newDefaultLibrary() else {
            return
        }
        
        guard let shader = library.makeFunction(name: shaderName) else {
            print("Couldn't make function named \(shaderName)")
            return
        }
        
        do {
            self.pipelineState = try device.makeComputePipelineState(function: shader)
        } catch {
            fatalError("failed to create pipeline state: \(error)")
        }
        
    }
    
    override func filter(withCommandBuffer commandBuffer: MTLCommandBuffer,
                         inputTexture: MTLTexture) -> MTLTexture {
        let outputTexture = self.outputTexture(forInputTexture: inputTexture)
        let computeEncoder = commandBuffer.makeComputeCommandEncoder()
        computeEncoder.setComputePipelineState(pipelineState)
        computeEncoder.setTexture(inputTexture, at: 0)
        computeEncoder.setTexture(outputTexture, at: 1)
        
        let threadGroups = self.threadGroups(forInputTexture: inputTexture)
        computeEncoder.dispatchThreadgroups(threadGroups,
                                            threadsPerThreadgroup: threadsPerGroup)
        computeEncoder.endEncoding()
        return outputTexture
    }
}
