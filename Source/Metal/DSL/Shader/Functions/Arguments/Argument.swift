//
//  Argument.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class Argument: CustomStringConvertible {
        
        // MARK: - Init
        
        let name: String
        let type: ShaderType
        var qualifier: Type.Qualifier
        init(name: String, type: ShaderType, qualifier: Type.Qualifier) {
            self.name = name
            self.type = type
            self.qualifier = qualifier
        }
        
        // MARK: - String Convertible
        
        var description: String {
            var typeReference: String
            if let structType = type as? Struct {
                typeReference = structType.name
            } else if let texture = type as? Texture2D {
                return texture.argumentDeclaration
            } else {
                typeReference = type(of: type).name
            }
            
            return typeReference + " \(name) " + qualifier.declaration
        }
    }
}
