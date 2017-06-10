//
//  AbstractComputeFilter.swift
//  Slate
//
//  Created by John Coates on 10/13/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import MetalKit

class ComputeFilter: AbstractFilter {
    override init(device: MTLDevice) {
        super.init(device: device)
        buildPipeline()
    }
    
    func buildPipeline() {
        fatalError("Filter \(self) must implement buildPipeline()")
    }
    
    // MARK: - Thread Groups
    
    lazy var threadsPerGroup: MTLSize = MTLSize(width: 8, height: 8, depth: 1)
    
    fileprivate var threadGroups: MTLSize?
    fileprivate var threadTextureSize: MTLSize?
    
    func threadGroups(forInputTexture inputTexture: MTLTexture) -> MTLSize {
        if let threadGroups = threadGroups, let threadTextureSize = threadTextureSize {
            if threadTextureSize.width == inputTexture.width,
                threadTextureSize.height == inputTexture.height {
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
    
}
