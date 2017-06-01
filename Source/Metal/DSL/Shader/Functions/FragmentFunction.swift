//
//  FragmentFunction.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

// MARK: - Class

extension RuntimeShader {
    class FragmentFunction: CustomStringConvertible {
        let name: String
        let returnType: ShaderPrimitive.Type
        weak var shader: RuntimeShader?
        init(name: String, returnType: ShaderPrimitive.Type,
             shader: RuntimeShader) {
            self.name = name
            self.returnType = returnType
            self.shader = shader
        }
        
        lazy var sampler: Sampler = {
            let sampler = Sampler(name: "constantSampler")
            self.statements.append(sampler.declaration)
            return sampler
        }()
        
        lazy var arguments: ArgumentsManager = ArgumentsManager(function: self)
        
        lazy var variables: VariablesManager = VariablesManager(function: self)
        
        var textures = [String : Any]()
        
        var returnValue: Variable?
        
        lazy var statements = [Statement]()
        
        var description: String {
            var contents = "fragment \(returnType.name) \(name)" +
            "(\(arguments)) {\n"
            
            for statement in statements {
                contents += "\t\(statement);\n"
            }
            
            if let returnValue = returnValue {
                guard let returnVariableName = returnValue.name else {
                    fatalError("Variable missing name")
                }
                contents += "\treturn \(returnVariableName)\n"
            }
            contents += "}\n"
            return contents
        }
    }
}

// MARK: - Extension

extension RuntimeShader {
    typealias FragmentClosure = (FragmentFunction) -> Void
    func buildFragmentFunction(name: String, returnType: ShaderPrimitive.Type,
                               build: FragmentClosure) {
        let function = FragmentFunction(name: name, returnType: returnType, shader: self)
        functions.append(function)
        build(function)
    }
}
