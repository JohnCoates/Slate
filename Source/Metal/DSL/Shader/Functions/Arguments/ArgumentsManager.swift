//
//  ArgumentsManager.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class ArgumentsManager {
        weak var function: FragmentFunction?
        init(function: FragmentFunction) {
            self.function = function
        }
        
        func texture(name: String) -> Texture2D {
            return Texture2D(name: name)
        }
        
        func type(name: String, type: Struct, qualifier: Type.Qualifier) -> Struct {
            return type
        }
    }
}
