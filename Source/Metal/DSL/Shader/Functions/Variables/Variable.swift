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

extension RuntimeShader.Variable {
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
            return RuntimeShader.Float4(name: name, type: .float4)
        }
    }
}
