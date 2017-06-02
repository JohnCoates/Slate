//
//  VertexOut.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class VertexOut: CompositeVariable {
        
        override class func add(toShader shader: RuntimeShader) -> ShaderType {
            let item = shader.defineStruct(name: "VertexOut")
            item.addMember(name: "position",
                           type: Float4.self, qualifier: .position)
            item.addMember(name: "textureCoordinates",
                           type: Float2.self, qualifier: .user(name: "texturecoord"))
            
            return item
        }
        
        // MARK: - Init
        
        required init(name: String) {
            super.init(name: name)
        }
        
        var position: Float4 {
            return self["position"]
        }
        
        var textureCoordinates: Float2 {
            return self["textureCoordinates"]
        }
    }
}
