//
//  AssignStatement.swift
//  Slate
//
//  Created by John Coates on 6/1/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class AssignStatement: Statement {
        let lhs: Variable
        let rhs: Variable
        init(lhs: Variable, rhs: Variable) {
            self.lhs = lhs
            self.rhs = rhs
            super.init(type: .assignment)
        }
        
        override var description: String {
            guard type == .assignment else {
                fatalError("Wrong type")
            }
            
            return "\(lhs.referenceValue) = \(rhs.referenceValue)"
        }
    }
}
