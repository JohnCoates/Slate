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
    
    override func filter(withCommandBuffer commandBuffer: MTLCommandBuffer,
                         inputTexture: MTLTexture) -> MTLTexture {
        if renderPipelineState == nil {
            buildRenderPipeline(label: "Chromatic Aberration",
                                vertexFunction: "vertexPassthrough",
                                fragmentFunction: "chromaticAberrationFragment")
        }

        return renderToOutputTexture(commandBuffer: commandBuffer, inputTexture: inputTexture)
    }
    
}

final class ChromaticAberrationFilter: ComputeFilter {
    
    var pipelineState: MTLComputePipelineState!
    
    override func buildPipeline() {
        let shaderName = "chromaticAberrationCompute"
        guard let library = device.makeDefaultLibrary() else {
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
        computeEncoder?.setComputePipelineState(pipelineState)
        computeEncoder?.setTexture(inputTexture, index: 0)
        computeEncoder?.setTexture(outputTexture, index: 1)
        
        let threadGroups = self.threadGroups(forInputTexture: inputTexture)
        computeEncoder?.dispatchThreadgroups(threadGroups,
                                            threadsPerThreadgroup: threadsPerGroup)
        computeEncoder?.endEncoding()
        return outputTexture
    }
    
}
