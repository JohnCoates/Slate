//
//  Renderer+Sampling.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Metal
import MetalKit

extension Renderer {
    
    class func makeSampler(withDevice device: MTLDevice) -> MTLSamplerState {
        let sampler = MTLSamplerDescriptor()
        sampler.minFilter = .nearest
        sampler.magFilter = .nearest
        sampler.mipFilter = .nearest
        sampler.maxAnisotropy = 1
        sampler.sAddressMode = .clampToZero
        sampler.tAddressMode = .clampToZero
        sampler.rAddressMode = .clampToZero
        sampler.normalizedCoordinates = true
        sampler.lodMinClamp = 0
        sampler.lodMaxClamp = 2
        #if os(iOS)
            sampler.lodAverage = false
        #endif
        sampler.label = "slateSampler"
        return device.makeSamplerState(descriptor: sampler)
    }
    
}
