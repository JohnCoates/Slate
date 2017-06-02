//
//  Struct.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

// MARK: - Class

extension RuntimeShader {
    class Struct: ShaderType {
        static var name: String = "struct"
        
        let name: String
        init(name: String) {
            self.name = name
        }
        
        var members = [Member]()
        func addMember(name: String, type: ShaderPrimitive.Type, qualifier: Type.Qualifier? = nil) {
            let member = Member(name: name, type: type, qualifier: qualifier)
            members.append(member)
        }
        
        var declaration: String {
            get {
                var contents = "struct \(name) {\n"
                for member in members {
                    contents += "\t" + member.declaration + "\n"
                }
                contents += "};\n"
                return contents
            }
        }
        
    }
}

// MARK: - Accessors

extension RuntimeShader.Struct {
    subscript (name: String) -> RuntimeShader.Float4 {
        get {
            return RuntimeShader.Float4(name: name, type: .float4)
        }
    }
}

// MARK: - Extension

extension RuntimeShader {
    func defineStruct(name: String) -> Struct {
        let item = Struct(name: name)
        structs.append(item)
        return item
    }
}
