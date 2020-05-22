//
//  Vertexes.swift
//  Slate
//
//  Created by John Coates on 9/30/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import MetalKit

struct Vertex {
    var position: SIMD4<Float>
}

struct Vertices {
    
    static func fullScreenQuad() -> [Vertex] {
        var vertices = [Vertex]()
        vertices.append(Vertex(position: SIMD4<Float>(-1, -1, 0, 1))) // left bottom
        vertices.append(Vertex(position: SIMD4<Float>(1, -1, 0, 1))) // right bottom
        vertices.append(Vertex(position: SIMD4<Float>(-1, 1, 0, 1))) // left top
        vertices.append(Vertex(position: SIMD4<Float>(1, -1, 0, 1))) // right bottom
        vertices.append(Vertex(position: SIMD4<Float>(-1, 1, 0, 1))) // left top
        vertices.append(Vertex(position: SIMD4<Float>(1, 1, 0, 1))) // right top
        return vertices
    }
    
    static let viewportWidth: Float = 2
    static let viewportHeight: Float = 2
    
    static func quadForAspectFill(input: Size, target: Size) -> [Vertex] {
        let inputRatio = input.width / input.height
        let targetRatio = target.width / target.height
        
        if inputRatio > targetRatio {
            let width = input.width * (target.height / input.height)
            
            return centeredQuadWithViewport(width: (width / target.width) * viewportWidth,
                                            height: viewportHeight)
        } else {
            let height = input.height * (target.width / input.width)
            return centeredQuadWithViewport(width: viewportWidth,
                                            height: (height / target.height) * viewportHeight)
        }
    }
    
    static func quadForAspectFit(input: Size, target: Size) -> [Vertex] {
        let inputRatio: Float = input.width / input.height
        let targetRatio: Float = target.width / target.width
        
        if targetRatio > inputRatio {
            let width = input.width * (target.height / input.height)
            
            return centeredQuadWithViewport(width: Float(width / target.width) * viewportWidth,
                                            height: viewportHeight)
        } else {
            let height = input.height * (target.width / input.width)
            return centeredQuadWithViewport(width: viewportWidth,
                                            height: Float(height / target.height) * viewportHeight)
        }
    }
    
    private static func fullWidthAspectRatio(width: Float, height: Float) -> [Vertex] {
        let inputWidth: Float = 720
        let inputHeight: Float = 1080
        let inputRatio: Float = inputWidth / inputHeight
        let targetRatio = width / height
        
        let viewportWidth: Float = 2
        let viewportHeight: Float = 2
        
        let viewportHeightRatio = inputRatio * targetRatio
        let viewportAspectHeight = viewportHeight * viewportHeightRatio
        return centeredQuadWithViewport(width: viewportWidth, height: viewportAspectHeight)
    }
    
    private static func centeredQuadWithViewport(width: Float, height: Float) -> [Vertex] {
        let xMin: Float, yMin: Float, xMax: Float, yMax: Float
        xMin = 0 - (width / 2)
        yMin = 0 - (height / 2)
        xMax = 0 + (width / 2)
        yMax = 0 + (height / 2)
        
        var vertices = [Vertex]()
        vertices.append(Vertex(position: SIMD4<Float>(xMin, yMin, 0, 1))) // left bottom
        vertices.append(Vertex(position: SIMD4<Float>(xMax, yMin, 0, 1))) // right bottom
        vertices.append(Vertex(position: SIMD4<Float>(xMin, yMax, 0, 1))) // left top
        vertices.append(Vertex(position: SIMD4<Float>(xMax, yMin, 0, 1))) // right bottom
        vertices.append(Vertex(position: SIMD4<Float>(xMin, yMax, 0, 1))) // left top
        vertices.append(Vertex(position: SIMD4<Float>(xMax, yMax, 0, 1))) // right top
        return vertices
    }
    
}
