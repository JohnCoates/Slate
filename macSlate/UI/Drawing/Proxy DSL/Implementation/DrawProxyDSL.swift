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
    static var currentFill: Path.Color?
    static var currentStroke: Path.Color?
    
    static func openCanvas(name: String, section: String, width: Float, height: Float) {
        
        print("starting canvas in section \(section): \(name) - \(width) x \(height)")
        canvas = Canvas(name: name, section: section, width: width, height: height)
    }
    
    static func closeCanvas() {
    }
}
