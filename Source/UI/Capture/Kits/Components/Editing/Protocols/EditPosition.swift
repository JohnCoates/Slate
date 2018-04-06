//
//  EditPosition.swift
//  Slate
//
//  Created by John Coates on 5/12/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

protocol EditPosition: class {
    var origin: CGPoint { get set }
    var center: CGPoint { get set }
}

extension EditPosition where Self: Component {
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame.origin = newValue
        }
    }
    
    var center: CGPoint {
        get {
            return view.center
        }
        set {
            view.center = newValue
        }
    }
}
