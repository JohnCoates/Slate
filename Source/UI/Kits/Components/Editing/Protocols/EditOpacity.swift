//
//  EditOpacity.swift
//  Slate
//
//  Created by John Coates on 5/21/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

protocol EditOpacity: class {
    var opacity: Float { get set }
    var minimumOpacity: Float { get }
    var maximumOpacity: Float { get }
    
    static var defaultOpacity: Float { get }
}

// MARK: - Defaults

extension EditOpacity {
    var minimumOpacity: Float {
        return 0
    }
    
    var maximumOpacity: Float {
        return 1
    }
}

// MARK: - Component

extension GenericComponent where Self: EditOpacity, ViewInstance: EditOpacity {
    
    var opacity: Float {
        get {
            return MainThread.get { typedView.opacity }
        }
        set {
            MainThread.sync {
                self.typedView.opacity = newValue
            }
        }
    }
}
