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
    var cgWidth: CGFloat {
        return CGFloat(width)
    }
    var cgHeight: CGFloat {
        return CGFloat(height)
    }
    
    init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
    
    init(_ size: CGSize) {
        self.width = Float(size.width)
        self.height = Float(size.height)
    }
    
    static var zero: Size {
        return Size(width: 0, height: 0)
    }
}

func * (lhs: Size, rhs: Int) -> Size {
    return Size(width: lhs.width * Float(rhs), height: lhs.height * Float(rhs))
}
