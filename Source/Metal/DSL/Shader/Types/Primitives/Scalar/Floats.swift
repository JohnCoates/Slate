//
//  Floats.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class Float4: TypedVariable, ShaderPrimitive {
        static var name: String = "float4"
    }
    class SIMD2<Float>: TypedVariable, ShaderPrimitive {
        static var name: String = "SIMD2<Float>"
    }
    class Float: TypedVariable, ShaderPrimitive {
        static var name: String = "float"
    }
}
