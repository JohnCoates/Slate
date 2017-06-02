//
//  ArgumentsManager.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class ArgumentsManager: CustomStringConvertible {
        
        // MARK: - Init
        
        weak var function: FragmentFunction?
        init(function: FragmentFunction) {
            self.function = function
        }
        
        // MARK: - Arguments
        
        lazy var arguments = [Argument]()
        
        // MARK: - Accessors
        
        func texture(name: String) -> Texture2D {
            let variable = Texture2D(name: name)
            let argument = Argument(name: name, type: variable, qualifier: .texture)
            arguments.append(argument)
            return variable
        }
        
        func type(name: String, type: Struct, qualifier: Type.Qualifier) -> Variable {
            let variable = Variable(name: name, type: .`struct`)
            let argument = Argument(name: name, type: type, qualifier: qualifier)
            arguments.append(argument)
            return variable
        }
        
        var description: String {
            return self.arguments.customJoined(separator: ", ")
        }
    }
}
