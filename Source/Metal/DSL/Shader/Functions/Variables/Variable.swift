//
//  Variable.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class Variable {
        var function: FragmentFunction?
        var name: String?
        var type: DataType
        var typeReference: String {
            switch type {
            case .float4:
                return "float4"
            case .sampler:
                return "sampler"
            case .`struct`:
                fatalError("Missing struct name")
            }
        }
        
        var referenceValue: String {
            if let name = name {
                return name
            } else if let statement = statement {
                return statement.description
            } else {
                fatalError("Missing reference value")
            }
        }
        
        var assignable = true
        
        init(name: String, type: DataType) {
            self.name = name
            self.type = type
        }
        
        var statement: Statement?
        init(statement: Statement, type: DataType) {
            self.statement = statement
            self.type = type
            assignable = false
        }
    }
}

// MARK: - Types

extension RuntimeShader {
    enum DataType {
        case float4
        case `struct`
        case sampler
    }
}

// MARK: - Subscripting

extension RuntimeShader.Variable {
    subscript (name: String) -> RuntimeShader.Float4 {
        get {
            guard type == .struct else {
                fatalError("Only structs are subscriptable")
            }
            let variable = RuntimeShader.CompositeMemberVariable(composite: self,
                                                                 member: name,
                                                                 type: .float4)
            return RuntimeShader.Float4(inner: variable)
        }
    }
}
