//
//  UIColor.swift
//  Slate
//
//  Created by John Coates on 6/3/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension DrawProxyDSL {
    class UIColor {
        let red: Float
        let green: Float
        let blue: Float
        let alpha: Float
        
        init(red: Float, green: Float, blue: Float, alpha: Float) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
        
        func setFill() {
            currentFill = color
        }
        
        func setStroke() {
            currentStroke = color
        }
        
        var color: Path.Color {
            return Path.Color(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}
