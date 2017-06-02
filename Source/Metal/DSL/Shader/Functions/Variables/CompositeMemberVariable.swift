//
//  CompositeMemberVariable.swift
//  Slate
//
//  Created by John Coates on 6/1/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class CompositeMemberVariable: Variable {
        let composite: Variable
        init(composite: Variable, member: String, type: DataType) {
            self.composite = composite
            super.init(name: member, type: type)
        }
        
        override var referenceValue: String {
            guard let member = name else {
                fatalError("Missing member name")
            }
            
            return "\(composite.referenceValue).\(member)"
        }
    }
    
}
