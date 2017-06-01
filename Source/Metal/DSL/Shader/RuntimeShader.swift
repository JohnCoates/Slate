//
//  RuntimeShader.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

class RuntimeShader: CustomStringConvertible {
    
    // MARK: - Init
    
    let identifier: String
    init(identifier: String) {
        self.identifier = identifier
    }
    
    // MARK: - Properties
    
    var structs = [Struct]()
    lazy var functions = [FragmentFunction]()
    
    // MARK: - String Conversion
    
    var header: String {
        return "#include <metal_stdlib>\n" +
               "using namespace metal;\n\n"
    }
    var description: String {
        var contents = header
        if structs.count > 0 {
            contents += "// Structs\n"
        }
        for composite in structs {
            contents += composite.declaration + "\n"
        }
        if functions.count > 0 {
            contents += "\n// Functions\n"
        }
        for function in functions {
            contents += "\(function)\n"
        }
        
        return contents
    }
}
