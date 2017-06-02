//
//  Statement.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable nesting

import Foundation

extension RuntimeShader {
    class Statement: CustomStringConvertible {
        enum StatementType {
            case assignment
            case declaration
            case functionCall
        }
        
        let type: StatementType
        var declare: Variable?
        init(declare: Variable) {
            self.type = .declaration
            self.declare = declare
        }
        
        init(type: StatementType) {
            if type == .declaration {
                fatalError("Wrong init for declaration")
            }
            self.type = type
        }
        
        var description: String {
            if type == .declaration {
                return variableDeclaration
            } else {
                fatalError("Unknown type")
            }
            return ""
        }
        
        var variableDeclaration: String {
            guard let declare = self.declare else {
                fatalError("Missing declaration variable")
            }
            guard let name = declare.name else {
                fatalError("Variable missing name")
            }
            
            if declare is Sampler {
                return "constexpr sampler \(name)"
            }
            
            return "\(declare.typeReference) \(name)"
        }
    }
}
