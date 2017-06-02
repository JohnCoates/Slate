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
        
        override var description: String {
            guard type == .functionCall else {
                fatalError("Wrong type")
            }
            
            var functionPrefix = ""
            if let object = object {
                functionPrefix = object.referenceValue + "."
            }
            var argumentsSeparatedByCommas = ""
            if let arguments = arguments {
                let referenceValues = arguments.map({$0.referenceValue})
                argumentsSeparatedByCommas = referenceValues.joined(separator: ", ")
            }
            return "\(functionPrefix)\(name)(\(argumentsSeparatedByCommas))"
        }
    }
}
