//
//  TextureCoordinates.swift
//  Slate
//
//  Created by John Coates on 9/30/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import MetalKit

struct TextureCoordinates {
    
    // iOS
    static func devicePortrait() -> [float2] {
        return [
            float2(0, 1),
            float2(1, 1),
            float2(0, 0),
            float2(1, 1),
            float2(0, 0),
            float2(1, 0)
        ]
    }
    
    static func macFlipped() -> [float2] {
        var coordinates = [float2]()
        coordinates.append(float2(0, 1))
        coordinates.append(float2(1, 1))
        coordinates.append(float2(0, 0))
        coordinates.append(float2(1, 1))
        coordinates.append(float2(0, 0))
        coordinates.append(float2(1, 0))
        return coordinates
    }
    
    static func macHorizontalFlipped() -> [float2] {
        var coordinates = [float2]()
        coordinates.append(float2(1, 1))
        coordinates.append(float2(0, 1))
        coordinates.append(float2(1, 0))
        coordinates.append(float2(0, 1))
        coordinates.append(float2(1, 0))
        coordinates.append(float2(0, 0))
        return coordinates
    }
}
