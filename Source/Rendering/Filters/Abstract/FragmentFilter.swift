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
}
