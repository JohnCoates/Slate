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
    
    // MARK: - Filtering
    
    func filter(withCommandBuffer commandBuffer: MTLCommandBuffer,
                inputTexture: MTLTexture) -> MTLTexture {
        fatalError("Filter \(self) must implement filter(withCommandBuffer:inputTexture:)")
    }
}
