//
//  VertexStructs.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    
    func vertexInType() -> Struct {
        let vertexInType: Struct = defineStruct(name: "VertexIn")
        vertexInType.addMember(name: "position", type: Float4.self)
        return vertexInType
    }
    
    func vertexOutType() -> Struct {
        let vertexOutType: Struct = defineStruct(name: "VertextOut")
        vertexOutType.addMember(name: "position", type: Float4.self, qualifier: .position)
        vertexOutType.addMember(name: "textureCoordinates",
                                type: SIMD2<Float>.self, qualifier: .user(name: "texturecoord"))
        return vertexOutType
    }
    
}
