//
//  Path.swift
//  Slate
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

class Path {
    var lineWidth: Float?
    var usesEvenOddFillRule = false
    var instructions = [Instruction]()
    
    func add(instruction: Instruction) {
        instructions.append(instruction)
    }
}
