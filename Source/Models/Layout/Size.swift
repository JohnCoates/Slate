//
//  Size.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreGraphics

struct Size {
    var width: Float
    var height: Float
    
    init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
    
    init(size: CGSize) {
        self.width = Float(size.width)
        self.height = Float(size.height)
    }
    
    static var zero: Size {
        return Size(width: 0, height: 0)
    }
}
