//
//  Member.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    struct Member {
        let name: String
        let type: ShaderPrimitive.Type
        var qualifier: ValueType.Qualifier?
        var declaration: String {
            // float2 textureCoordinates [[ user(texturecoord) ]];
            var contents = "\(type.name) \(name)"
            if let qualifier = qualifier?.declaration {
                contents += " \(qualifier)"
            }
            contents += ";"
            
            return contents
        }
    }
}
