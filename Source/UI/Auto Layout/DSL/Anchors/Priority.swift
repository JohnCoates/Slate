//
//  Priority.swift
//  Slate
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

#if os(iOS)
    import UIKit
    typealias CorePriority = UILayoutPriority
#else
    import AppKit
    typealias CorePriority = NSLayoutPriority
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
    
    var rawValue: CorePriority {
        switch self {
        case .ultraLow:
            #if os(iOS)
                return UILayoutPriorityDefaultLow - 1
            #else
                return NSLayoutPriorityDefaultLow - 1
            #endif
        case .low:
            #if os(iOS)
                return UILayoutPriorityDefaultLow
            #else
                return NSLayoutPriorityDefaultLow
            #endif
        case .high:
            #if os(iOS)
                return UILayoutPriorityDefaultHigh
            #else
                return NSLayoutPriorityDefaultHigh
            #endif
        case .ultraHigh:
            #if os(iOS)
                return UILayoutPriorityDefaultHigh + 1
            #else
                return NSLayoutPriorityDefaultHigh + 1
            #endif
        case .required:
            #if os(iOS)
                return UILayoutPriorityRequired
            #else
                return NSLayoutPriorityRequired
            #endif
        case .custom(let custom):
            return custom
        }
    }
}
