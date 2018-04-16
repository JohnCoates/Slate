//
//  Enum+SubscriptByAssociatedValueName
//  Created on 4/16/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

protocol SubscriptByAssociatedValueName { }

extension SubscriptByAssociatedValueName {
    subscript<T>(name: String) -> T {
        let mirror = Mirror(reflecting: self)
        let children = mirror.children.first!
        let childrenMirror = Mirror(reflecting: children.value)
        let child = childrenMirror.children.filter({ $0.label! == name }).first!
        // swiftlint:disable:next force_cast
        return child.value as! T
    }
}
