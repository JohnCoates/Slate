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
        
        func add(instruction: Path.Instruction) {
            if let path = DrawProxyDSL.currentPath {
                path.add(instruction: instruction)
            } else if let canvas = DrawProxyDSL.canvas {
                canvas.instructions.append(instruction)
            } else {
                fatalError("Can't add graphics context command!")
            }
        }
        
        func saveGState() {
            add(instruction: .contextSaveGState)
            
        }
        
        func restoreGState() {
            add(instruction: .contextRestoreGState)
        }
        
        func translateBy(x: Float, y: Float) {
            add(instruction: .contextTranslateBy(x: x, y: y))
        }
    
        func rotate(by: CGFloat) {
            add(instruction: .contextRotate(by: Float(by)))
        }
        
    }
}

func UIGraphicsGetCurrentContext() -> DrawProxyDSL.GraphicsContext? {
    return DrawProxyDSL.GraphicsContext()
}
