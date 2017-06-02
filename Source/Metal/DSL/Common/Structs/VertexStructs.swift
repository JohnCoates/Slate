//
//  VertexStructs.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation

extension RuntimeShader {
    func VertexInType() -> Struct {
        let VertexInType: Struct = defineStruct(name: "VertexIn")
        VertexInType.addMember(name: "position", type: Float4.self)
        return VertexInType
    }
    
    func VertexOutType() -> Struct {
        let VertexOutType: Struct = defineStruct(name: "VertextOut")
        VertexOutType.addMember(name: "position", type: Float4.self, qualifier: .position)
        VertexOutType.addMember(name: "textureCoordinates", type: Float2.self, qualifier: .user(name: "texturecoord"))
        return VertexOutType
    }
}
