//
//  Path.swift
//  Slate
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

class Path {
    var instructions = [Instruction]()
    
    func add(instruction: Instruction) {
        instructions.append(instruction)
    }
    
    struct Point {
        let x: Float
        let y: Float
    }
    struct Rect {
        let origin: Point
        let size: Point
    }
    
    struct Color: Equatable {
        let red: Float
        let green: Float
        let blue: Float
        let alpha: Float
    }
}
