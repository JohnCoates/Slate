//
//  EditSize.swift
//  Slate
//
//  Created by John Coates on 5/12/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

protocol EditSize: class {
    var size: Float { get set }
    var minimumSize: Float { get }
    var maximumSize: Float { get }
}

// MARK: - Defaults

extension EditSize {
    var minimumSize: Float {
        return 20
    }
    
    var maximumSize: Float {
        return 200
    }
}

extension EditSize where Self: Component {
    var size: Float {
        get {
            return Float(frame.size.width)
        }
        set {
            var frame = self.frame
            let difference: CGFloat
            difference = CGFloat(newValue) - frame.size.width
            // center
            frame.origin.x -= (difference / 2)
            frame.origin.y -= (difference / 2)
            
            frame.size.width = CGFloat(newValue)
            frame.size.height = CGFloat(newValue)
            self.frame = frame
        }
    }
}
