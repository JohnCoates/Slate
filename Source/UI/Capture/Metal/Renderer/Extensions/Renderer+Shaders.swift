//
//  Renderer+Shaders.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Metal
import MetalKit

extension Renderer {
    
    // MARK: - Library
    
    class func getDefaultLibrary(withDevice device: MTLDevice)
        -> (library: MTLLibrary,
        vertexFunction: MTLFunction,
        fragmentFunction: MTLFunction)? {
            
            guard let library = device.makeDefaultLibrary() else {
                fatalError("Couldn't find shader libary")
            }
            
            // Retrieve the functions that will comprise our pipeline
            guard let vertexFunction = library.makeFunction(name: "vertexPassthrough"),
                let fragmentFunction = library.makeFunction(name: "fragmentPassthroughWithExistingSampler") else {
                    print("Couldn't get shader functions")
                    return nil
            }
            
            return (library: library,
                    vertexFunction: vertexFunction,
                    fragmentFunction: fragmentFunction)
    }
    
    // MARK: - Shader Updates
    
    func updateShader(withLibrary library: MTLLibrary,
                      shaderFunction functionName: String) {
        guard let fragmentFunction = library.makeFunction(name: functionName) else {
            print("Failed to make fragment function: \(functionName)")
            return
        }
        
        do {
            let pipeline = try buildRenderPipeline(withFragmentFunction: fragmentFunction)
            renderPipelineState = pipeline
            
        } catch {
            print("Error updating shader: \(error)")
        }
        
    }
    
}
