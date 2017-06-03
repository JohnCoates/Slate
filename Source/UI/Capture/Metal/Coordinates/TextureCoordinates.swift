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
    
    // Normalized
    static let textureWidth: Float = 1
    static let textureHeight: Float = 1
    
    static func quadForAspectFill(input: Size, target: Size) -> [float2] {
        let inputRatio = input.width / input.height
        let targetRatio = target.width / target.height
        
        if inputRatio > targetRatio {
            let width = input.width * (target.height / input.height)
            
            return centeredQuad(width: target.width / width, height: textureHeight)
        } else {
            let height = input.height * (target.width / input.width)
            return centeredQuad(width: textureWidth, height: target.height / height)
        }
    }
    
    static func quadForAspectFit(input: Size, target: Size) -> [float2] {
        let inputRatio: Float = input.width / input.height
        let targetRatio: Float = target.width / target.width
        
        if targetRatio > inputRatio {
            let width = input.width * (target.height / input.height)
            return centeredQuad(width: (target.width / width), height: textureHeight)
        } else {
            let height = input.height * (target.width / input.width)
            return centeredQuad(width: textureWidth, height: (target.height / height))
        }
    }
    
    static func centeredQuad(width: Float, height: Float) -> [float2] {
        let xMin: Float, yMin: Float, xMax: Float, yMax: Float
        xMin = 0.5 - (width / 2)
        yMin = 0.5 - (height / 2)
        xMax = 0.5 + (width / 2)
        yMax = 0.5 + (height / 2)
        return [
            float2(xMin, yMax),
            float2(xMax, yMax),
            float2(xMin, yMin),
            float2(xMax, yMax),
            float2(xMin, yMin),
            float2(xMax, yMin)
        ]
    }
    
    static func iOSDevicePortrait() -> [float2] {
        return centeredQuad(width: textureWidth, height: textureHeight)
    }
    
    static func macFlipped() -> [float2] {
        return centeredQuad(width: textureWidth, height: textureHeight)
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
