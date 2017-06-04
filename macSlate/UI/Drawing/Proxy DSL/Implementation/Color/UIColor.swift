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
        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double
        
        init(red: Double, green: Double, blue: Double, alpha: Double) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
        
        func setFill() {
        }
    }
}
