//
//  GraphicsContext.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension DrawProxyDSL {
    class GraphicsContext {
        func saveGState() {
        }
        func restoreGState() {
        }
        
        func translateBy(x: Float, y: Float) {
        }
    
        func rotate(by: CGFloat) {
        }    
    }
}

func UIGraphicsGetCurrentContext() -> DrawProxyDSL.GraphicsContext? {
    return DrawProxyDSL.GraphicsContext()
}
