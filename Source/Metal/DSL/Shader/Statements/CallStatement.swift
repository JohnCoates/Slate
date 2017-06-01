//
//  CallStatement.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class CallStatement: Statement {
        weak var object: Variable?
        let name: String
        let arguments: [Variable]?
        init(object: Variable, name: String, arguments: [Variable]? = nil) {
            self.object = object
            self.name = name
            self.arguments = arguments
            super.init(type: .functionCall)
        }
    }
}
