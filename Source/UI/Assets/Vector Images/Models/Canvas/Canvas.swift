//
//  Canvas.swift
//  Slate
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

class Canvas {
    let name: String
    let section: String
    let width: Float
    let height: Float
    
    var instructions: [Path.Instruction] = Array()
    var paths = [Path]()
    
    init(name: String, section: String, width: Float, height: Float) {
        self.name = name
        self.section = section
        
        self.width = width
        self.height = height
    }
    
    lazy var identifier: String = {
        return "\(self.section).\(self.name)"
    }()
}
