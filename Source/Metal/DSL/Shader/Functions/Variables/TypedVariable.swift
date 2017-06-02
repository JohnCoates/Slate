//
//  TypedVariable.swift
//  Slate
//
//  Created by John Coates on 6/1/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class TypedVariable: Variable {
        var inner: Variable?
        
        convenience init(inner: Variable) {
            if let name = inner.name {
                self.init(name: name, type: inner.type)
            } else if let statement = inner.statement {
                self.init(statement: statement, type: inner.type)
            } else {
                fatalError("Invalid inner variable")
            }
            
            self.inner = inner
        }
        
        override var referenceValue: String {
            if let inner = inner {
                return inner.referenceValue
            } else {
                return super.referenceValue
            }
            
        }
    }
    
}
