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
            case .float, .float2, .float4, .sampler:
                return type.rawValue
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
    enum DataType: String {
        case float
        case float2
        case float4
        case `struct`
        case sampler
    }
}
