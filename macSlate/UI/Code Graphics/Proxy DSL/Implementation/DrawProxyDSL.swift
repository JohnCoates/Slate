//
//  DrawProxyDSL.swift
//  Slate
//
//  Created by John Coates on 6/3/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

class DrawProxyDSL {
    static var canvas: Canvas?
    static var currentPath: Path?
    static var currentFill: Path.Color?
    static var currentStroke: Path.Color?
    
    static func pushCanvas(name: String, section: String, width: Float, height: Float) {
        print("exporting canvas \(section): \(name) - \(width) x \(height)")
        canvas = Canvas(name: name, section: section, width: width, height: height)
    }
    
    static func popCanvas() -> Canvas {
        guard let canvas = canvas else {
            fatalError("Invalid pop, missing canvas")
        }
        DrawProxyDSL.canvas = nil
        return canvas
    }
    
    static func UIGraphicsGetCurrentContext() -> GraphicsContext? {
        return GraphicsContext()
    }
}
