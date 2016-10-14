//
//  GaussianBlurFilter.swift
//  Slate
//
//  Created by John Coates on 10/2/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import Metal

class GaussianBlurFilter: FragmentFilter {
    override func filter(withCommandBuffer commandBuffer: MTLCommandBuffer,
                         inputTexture: MTLTexture) -> MTLTexture {
        if renderPipelineState == nil {
            buildRenderPipeline(label: "Gaussian Blur",
                                vertexFunction: "vertexPassthrough",
                                fragmentFunction: "gaussianBlurFragment")
        }
        
        return renderToOutputTexture(commandBuffer: commandBuffer, inputTexture: inputTexture)
    }
}
