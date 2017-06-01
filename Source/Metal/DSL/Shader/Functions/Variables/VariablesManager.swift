//
//  VariablesManager.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class VariablesManager: CustomStringConvertible {
        
        // MARK: - Init
        
        weak var function: FragmentFunction?
        init(function: FragmentFunction) {
            self.function = function
        }
        
        // MARK: - Arguments
        
        lazy var arguments = [Variable]()
        
        // MARK: - Accessors
        
        func texture(name: String) -> Texture2D {
            return Texture2D(name: name)
        }
        
        func type(name: String, type: Struct, qualifier: Type.Qualifier) -> Variable {
            let variable = Variable(name: name, type: .`struct`)
            return variable
        }
        
        func addTypeDeclaration(variable: Variable) {
            guard let name = variable.name else {
                fatalError("Variable missing name")
            }
            let statement = Statement(declare: variable)
            function?.statements.append(statement)
        }
        
        var description: String {
            return "arguments here"
        }
    }
}


// MARK: - Subscripting

extension RuntimeShader.VariablesManager {
    subscript (name: String) -> RuntimeShader.Float4 {
        get {
            let variable = RuntimeShader.Float4(name: name, type: .float4)
            addTypeDeclaration(variable: variable)
            return RuntimeShader.Float4(name: name, type: .float4)
        }
    }
}


