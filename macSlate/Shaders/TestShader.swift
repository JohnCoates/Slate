//
//  TestShader.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    static func testRuntimeShaderBuild() {
        let shader = buildRuntimeShader(identifier: "fragmentPassthrough") { shader in
            let VertexInType: Struct = shader.defineStruct(name: "VertexIn")
            VertexInType.addMember(name: "position", type: Float4.self)
            
            let VertexOutType: Struct = shader.defineStruct(name: "VertextOut")
            VertexOutType.addMember(name: "position", type: Float4.self, qualifier: .position)
            VertexOutType.addMember(name: "textureCoordinates", type: Float2.self, qualifier: .user(name: "texturecoord"))
            
            shader.buildFragmentFunction(name: "fragmentPassthrough") { function in
                let arguments = function.arguments
                let texture: Texture2D = arguments.texture(name: "texture")
                texture.configure(access: .sample, type: Float.self, index: 0)
                let sampler = function.sampler
                let fragmentIn = arguments.type(name: "fragmentIn", type: VertexOutType, qualifier: .stageIn)
                let coordinates: Float4 = fragmentIn["textureCoordinates"]
                let color = texture.sample(sampler: sampler, coordinates: coordinates)
                
                function.returnValue = color
            }
            
        }
        
        print("runtime shader: \(shader)")
    }
}


func testRuntimeShaderBuild() {
    RuntimeShader.testRuntimeShaderBuild()
}
