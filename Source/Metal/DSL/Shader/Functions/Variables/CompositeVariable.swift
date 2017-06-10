//
//  CompositeVariable.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class CompositeVariable: Variable {
        
        class func add(toShader shader: RuntimeShader) -> ShaderType {
            fatalError("Subclass must override this method")
        }
        
        required init(name: String) {
            super.init(name: name, type: .`struct`)
        }
    }
}

// MARK: - Subscripting

extension RuntimeShader.CompositeVariable {
    
    subscript(name: String) -> RuntimeShader.Float4 {
        let variable = RuntimeShader.CompositeMemberVariable(composite: self,
                                                             member: name,
                                                             type: .float4)
        return RuntimeShader.Float4(inner: variable)
    }
    
    subscript(name: String) -> RuntimeShader.Float2 {
        let variable = RuntimeShader.CompositeMemberVariable(composite: self,
                                                             member: name,
                                                             type: .float2)
        return RuntimeShader.Float2(inner: variable)
    }
}
