//
//  ChromaticAberrationFilter.swift
//  Slate
//
//  Created by John Coates on 10/2/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import MetalKit

class ChromaticAberrationFilter: AbstractFilter {
    
    let device: MTLDevice
    init(device: MTLDevice) {
        self.device = device
        super.init()
        buildPipeline()
    }
    
    var pipelineState: MTLComputePipelineState!
    func buildPipeline() {
//        let pixelFormat = MTLPixelFormat.depth32Float
//        let stencilFormat = MTLPixelFormat.invalid
//        let sampleCount = 1
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
    var outputTexture: MTLTexture?
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
    
    lazy var threadGroupSize: MTLSize = MTLSize(width: 16, height: 16, depth: 1)
    var threadGroupCount: MTLSize?
    var threadTextureSize: MTLSize?
    func threadGroupCount(forInputTexture inputTexture: MTLTexture) -> MTLSize {
        if let threadGroupCount = threadGroupCount, let threadTextureSize = threadTextureSize {
            if threadTextureSize.width == inputTexture.width, threadTextureSize.height == inputTexture.height {
                return threadGroupCount
            }
        }
        let widthSteps = (inputTexture.width + threadGroupSize.width - 1) / threadGroupSize.width
        let heightSteps = (inputTexture.height + threadGroupSize.height - 1) / threadGroupSize.height
        let count = MTLSizeMake(widthSteps, heightSteps, 1)
        threadGroupCount = count
        threadTextureSize = MTLSize(width: inputTexture.width,
                                    height: inputTexture.height,
                                    depth: inputTexture.depth)
        return count
    }
    
    func filter(withCommandBuffer commandBuffer: MTLCommandBuffer,
                inputTexture: MTLTexture) -> MTLTexture {
        let outputTexture = self.outputTexture(forInputTexture: inputTexture)
        let computeEncoder = commandBuffer.makeComputeCommandEncoder()
        computeEncoder.setComputePipelineState(pipelineState)
        computeEncoder.setTexture(inputTexture, at: 0)
        computeEncoder.setTexture(outputTexture, at: 1)
        
        let threadGroupCount = self.threadGroupCount(forInputTexture: inputTexture)
        let threads = threadGroupSize
        computeEncoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threads)
        computeEncoder.endEncoding()
        return outputTexture
    }
}
