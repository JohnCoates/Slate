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

class ChromaticAberrationFilter: AbstractFilter {
    
    let device: MTLDevice
    init(device: MTLDevice) {
        self.device = device
        super.init()
        buildPipeline()
    }
    
    var pipelineState: MTLComputePipelineState!
    func buildPipeline() {
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
    
    lazy var threadsPerGroup: MTLSize = MTLSize(width: 16, height: 16, depth: 1)
    var threadGroups: MTLSize?
    var threadTextureSize: MTLSize?
    func threadGroups(forInputTexture inputTexture: MTLTexture) -> MTLSize {
        if let threadGroups = threadGroups, let threadTextureSize = threadTextureSize {
            if threadTextureSize.width == inputTexture.width, threadTextureSize.height == inputTexture.height {
                return threadGroups
            }
        }
        let widthSteps = inputTexture.width / threadsPerGroup.width
        let heightSteps = inputTexture.height / threadsPerGroup.height
        let groups = MTLSizeMake(widthSteps, heightSteps, 1)
        threadGroups = groups
        threadTextureSize = MTLSize(width: inputTexture.width,
                                    height: inputTexture.height,
                                    depth: inputTexture.depth)
        return groups
    }
    
    func filter(withCommandBuffer commandBuffer: MTLCommandBuffer,
                inputTexture: MTLTexture) -> MTLTexture {
        let outputTexture = self.outputTexture(forInputTexture: inputTexture)
        let computeEncoder = commandBuffer.makeComputeCommandEncoder()
        computeEncoder.setComputePipelineState(pipelineState)
        computeEncoder.setTexture(inputTexture, at: 0)
        computeEncoder.setTexture(outputTexture, at: 1)
        
        let threadGroups = self.threadGroups(forInputTexture: inputTexture)
        computeEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadsPerGroup)
        computeEncoder.endEncoding()
        return outputTexture
    }
}
