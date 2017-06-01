//
//  Argument.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class Argument {
        
        // MARK: - Init
        
        let name: String
        let type: ShaderType
        var qualifier: Type.Qualifier
        init(name: String, type: ShaderType, qualifier: Type.Qualifier) {
            self.name = name
            self.type = type
            self.qualifier = qualifier
        }
    }
}
