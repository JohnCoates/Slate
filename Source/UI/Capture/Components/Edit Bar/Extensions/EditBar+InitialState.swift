//
//  EditBar+InitialState.swift
//  Slate
//
//  Created by John Coates on 6/3/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreGraphics

extension ComponentEditBar {
    enum SupportedProperty {
        case position
        case size
        case rounding
        case opacity
    }
    
    func resetToInitialState(component: Component) {
        if let target = component as? EditPosition {
            guard let value = initialValues[.position] as? CGPoint else {
                fatalError("Didn't record initial position for component: \(component)")
            }
            target.origin = value
        }
        if let target = component as? EditSize {
            guard let value = initialValues[.size] as? Float else {
                fatalError("Didn't record initial size for component: \(component)")
            }
            target.size = value
        }
        if let target = component as? EditRounding {
            guard let value = initialValues[.rounding] as? Float else {
                fatalError("Didn't record initial rounding for component: \(component)")
            }
            target.rounding = value
        }
        if let target = component as? EditOpacity {
            guard let value = initialValues[.opacity] as? Float else {
                fatalError("Didn't record initial opacity for component: \(component)")
            }
            target.opacity = value
        }
    }
    
    func clearInitialState() {
        initialValues.removeAll()
    }
    
}
