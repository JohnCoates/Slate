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
    var position: float4
}

struct Vertices {
    static func quad() -> [Vertex] {
        var vertices = [Vertex]()
        vertices.append(Vertex(position: float4(-1, -1, 0, 1))) // left bottom
        vertices.append(Vertex(position: float4(1, -1, 0, 1))) // right bottom
        vertices.append(Vertex(position: float4(-1, 1, 0, 1))) // left top
        vertices.append(Vertex(position: float4(1, -1, 0, 1))) // right bottom
        vertices.append(Vertex(position: float4(-1, 1, 0, 1))) // left top
        vertices.append(Vertex(position: float4(1, 1, 0, 1))) // right top
        return vertices
    }
    
    static func quadForAspectRatio(width: Float, height: Float) -> [Vertex] {
        var xMin: Float, yMin: Float, xMax: Float, yMax: Float
        
        let inputWidth: Float = 720
        let inputHeight: Float = 1080
        let inputRatio: Float = inputWidth / inputHeight
        let targetRatio = width / height
        
        let viewportWidth: Float = 2
        let viewportHeight: Float = 2
        
        let viewportHeightRatio = inputRatio * targetRatio
        let viewportAspectHeight = viewportHeight * viewportHeightRatio
//        print("target: \(width),\(height): \(targetRatio)")
//        print("viewport  ratio: \(viewportHeightRatio)")
        
        xMin = 0 - (viewportWidth / 2)
        yMin = 0 - (viewportAspectHeight / 2)
        xMax = 0 + (viewportWidth / 2)
        yMax = 0 + (viewportAspectHeight / 2)
        
        var vertices = [Vertex]()
        vertices.append(Vertex(position: float4(xMin, yMin, 0, 1))) // left bottom
        vertices.append(Vertex(position: float4(xMax, yMin, 0, 1))) // right bottom
        vertices.append(Vertex(position: float4(xMin, yMax, 0, 1))) // left top
        vertices.append(Vertex(position: float4(xMax, yMin, 0, 1))) // right bottom
        vertices.append(Vertex(position: float4(xMin, yMax, 0, 1))) // left top
        vertices.append(Vertex(position: float4(xMax, yMax, 0, 1))) // right top
        return vertices
    }
}
