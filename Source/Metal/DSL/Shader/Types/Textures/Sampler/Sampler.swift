
//
//  Sampler.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class Sampler: Variable {
        init(name: String) {
            super.init(name: name, type: .sampler)
        }
        
        var declaration: Statement {
            return Statement(declare: self)
        }
    }
}
