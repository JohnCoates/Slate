//
//  ShaderType.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

protocol ShaderType: class {
    static var name: String { get }
}

extension RuntimeShader {
    class ValueType {
        enum Qualifier {
            case stageIn
            case position
            case texture
            case user(name: String)
            
            var declaration: String {
                let inner: String
                switch self {
                case .stageIn:
                    inner = "stage_in"
                case .position:
                    inner = "position"
                case .user(let name):
                    inner = "user(\(name))"
                case .texture:
                    inner = "texture"
                }
                
                return "[[ \(inner) ]]"
            }
        }
    }
    
}
