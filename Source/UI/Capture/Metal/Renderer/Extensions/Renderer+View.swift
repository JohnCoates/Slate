//
//  Renderer+View.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Metal
import MetalKit

extension Renderer {
    
    // MARK: - Setup
    
    func setUpMetalView() {
        // MetalPerformanceShaders are a compute framework
        // Drawable texture is written to, not rendered to
        view.framebufferOnly = false
        // Draw loop is managed manually whenever new frame is received
        view.isPaused = false
        view.delegate = self
        view.device = device
        view.clearColor = MTLClearColorMake(1, 1, 1, 1)
        view.colorPixelFormat = .bgra8Unorm
    }
    
    // MARK: - Rendering
    
    func render(toView view: MTKView) {
        guard let currentDrawable = view.currentDrawable, dirtyTexture else {
            return
        }
        
        dirtyTexture = false
        
        guard let texture = self.texture else {
            return
        }
        
        if let verticesUpdate = verticesUpdate {
            replaceVertexBufferWhileOutsideOfCommandBufferBoundary(newVertices: verticesUpdate)
            self.verticesUpdate = nil
        }
        
        // Our command buffer is a container for the work we want to perform with the GPU.
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        #if METAL_DEVICE
            if useFilters {
                let filteredTexture = filterTexture(texture, withCommandBuffer: commandBuffer)
                renderFullScreen(commandBuffer: commandBuffer,
                                 drawable: currentDrawable,
                                 inputTexture: filteredTexture)
            } else {
                renderFullScreen(commandBuffer: commandBuffer,
                                 drawable: currentDrawable,
                                 inputTexture: texture)
            }
        #endif
        
        // Tell the system to present the cleared drawable to the screen.
        commandBuffer.present(currentDrawable)
        
        // Now that we're done issuing commands, we commit our buffer so the GPU can get to work.
        commandBuffer.commit()
    }
}
