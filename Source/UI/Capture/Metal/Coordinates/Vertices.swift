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
}
