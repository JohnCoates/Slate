//
//  VariableOperators.swift
//  Slate
//
//  Created by John Coates on 6/1/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

@discardableResult func == (lhs: RuntimeShader.Variable,
                            rhs: RuntimeShader.Variable) -> RuntimeShader.Statement {
    guard let function = lhs.function else {
        fatalError("Missing function in variable setter")
    }
    let statement = RuntimeShader.AssignStatement(lhs: lhs, rhs: rhs)
    function.add(statement: statement)
    return statement
}
