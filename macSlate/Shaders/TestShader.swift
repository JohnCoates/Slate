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
//            let vertexInType = shader.vertexInType()
//            let vertexOutType = shader.vertexOutType()
            
            shader.buildFragmentFunction(name: "fragmentPassthrough", returnType: Float4.self) { function in
//                let arguments = function.arguments
                let variables = function.variables
//                let texture: Texture2D = arguments.texture(name: "texture")
//                texture.configure(access: .sample, type: Float.self, index: 0)
//                let sampler = function.sampler
//                let fragmentIn = arguments.type(name: "fragmentIn", type: VertexOutType, qualifier: .stageIn)
//                let coordinates: Float4 = fragmentIn["textureCoordinates"]
                let color: Float4 = variables["color"]
//                color == texture.sample(sampler: sampler, coordinates: coordinates)
                
                function.returnValue = color
            }
        }
        
        print("runtime shader: \(shader)")
    }
    
}

func testRuntimeShaderBuild() {
    RuntimeShader.testRuntimeShaderBuild()
}
