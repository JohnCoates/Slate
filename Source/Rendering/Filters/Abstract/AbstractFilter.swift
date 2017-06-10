//
//  AbstractFilter
//  Slate
//
//  Created by John Coates on 10/2/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import MetalKit

class AbstractFilter {
    
    let device: MTLDevice
    init(device: MTLDevice) {
        self.device = device
    }
    
    // MARK: - Textures
    
    fileprivate var outputTexture: MTLTexture?
    
    func outputTexture(forInputTexture inputTexture: MTLTexture) -> MTLTexture {
        if let outputTexture = outputTexture {
            if outputTexture.width == inputTexture.width, outputTexture.height == inputTexture.height {
                return outputTexture
            }
            
        }
        print("texture width: \(inputTexture.width)")
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                  width: inputTexture.width,
                                                                  height: inputTexture.height,
                                                                  mipmapped: false)
        descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        let texture = device.makeTexture(descriptor: descriptor)
        outputTexture = texture
        return texture
    }
    
    // MARK: - Filtering
    
    func filter(withCommandBuffer commandBuffer: MTLCommandBuffer,
                inputTexture: MTLTexture) -> MTLTexture {
        fatalError("Filter \(self) must implement filter(withCommandBuffer:inputTexture:)")
    }
    
}
