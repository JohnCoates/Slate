//
//  EditRounding
//  Slate
//
//  Created by John Coates on 5/12/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

protocol EditRounding: class {
    var rounding: Float { get set }
    static var defaultRounding: Float { get }
}

// MARK: - Component

extension GenericComponent where Self: EditRounding, ViewInstance: EditRounding {
    
    static var defaultRounding: Float { return 1 }
    static var defaultOpacity: Float { return 1 }
    
    var rounding: Float {
        get {
            return typedView.rounding
        }
        set {
            typedView.rounding = newValue
        }
    }
}
