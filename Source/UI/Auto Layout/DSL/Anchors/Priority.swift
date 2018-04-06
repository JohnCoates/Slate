//
//  Priority.swift
//  Slate
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

enum Priority: ExpressibleByIntegerLiteral {
    case ultraLow
    case low
    case high
    case ultraHigh
    case required
    case custom(custom: Float)
    
    init(integerLiteral value: IntegerLiteralType) {
        self = .custom(custom: Float(value))
    }
    
    var rawValue: LayoutPriority {
        switch self {
        case .ultraLow:
                return LayoutPriority.defaultLow - 1
        case .low:
                return LayoutPriority.defaultLow
        case .high:
                return LayoutPriority.defaultHigh
        case .ultraHigh:
                return LayoutPriority.defaultHigh + 1
        case .required:
                return LayoutPriority.required
        case .custom(let custom):
            return LayoutPriority(rawValue: custom)
        }
    }
}
