//
//  Texture2D.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class Texture2D: ShaderType {
        static var name: String = "texture2d"
        
        // MARK: - Init
        
        let name: String
        init(name: String) {
            self.name = name
        }
        
        // MARK: - Configure
        
        func configure(access: Texture.Access, type: ShaderPrimitive.Type,
                       index: Int = 0) {
            self.access = access
            self.type = type
            self.index = index
        }
        
        var access: Texture.Access = .sample
        var type: ShaderPrimitive.Type = Float.self
        var index: Int = 0
        
        // MARK: - Statements
        
        func sample(sampler: Sampler, coordinates: Float2) -> Float4 {
            let statement = CallStatement(object: sampler,
                                          name: "sample", arguments: [coordinates])
            return Float4(statement: statement, type: .float4)
        }
        
        // MARK: - Declaration
        
        var argumentDeclaration: String {
            let access = self.access.rawValue
            let type = self.type.name
            return Texture2D.name + "<\(type), access::\(access)> \(name) [[ texture(\(index)) ]]"
        }
    }
}
