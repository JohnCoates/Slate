//
//  SmartPin.swift
//  Slate
//
//  Created by John Coates on 6/19/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class SmartPin {
    
    enum Anchor {
        case min(offset: CGFloat)
        case max(offset: CGFloat)
        case center(offset: CGFloat)
        case division(base: Int, index: Int, offset: CGFloat)
    }
    
    var nativeX: Anchor
    var nativeY: Anchor
    
    var foreignX: Anchor
    var foreignY: Anchor
    
    init(nativeX: Anchor, nativeY: Anchor, foreignX: Anchor, foreignY: Anchor) {
        self.nativeX = nativeX
        self.nativeY = nativeY
        self.foreignX = foreignX
        self.foreignY = foreignY
    }
    
}
