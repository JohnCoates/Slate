//
//  Renderer+Device.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Metal
import MetalKit

extension Renderer {
    
    class func getDevice() -> MTLDevice {
        #if os(iOS)
            if let defaultDevice = MTLCreateSystemDefaultDevice() {
                return defaultDevice
            } else {
                fatalError("Metal is not supported")
            }
        #endif
        
        #if os(macOS)
            let devices = MTLCopyAllDevices()
            switch devices.count {
            case 0:
                fatalError("Metal is not supported")
            case 2:
                // temporary workaround for bug that gives bad
                // performance on discrete GPU
                return devices[1]
            default:
                return devices[0]
            }
        #endif
    }

}
