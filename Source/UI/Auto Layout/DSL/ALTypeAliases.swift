//
//  ALTypeAliases.swift
//  Created on 4/6/18
//

import Foundation

#if os(iOS)
    import UIKit
    typealias LayoutAttribute = NSLayoutAttribute
    typealias LayoutRelation = NSLayoutRelation
    typealias LayoutPriority = UILayoutPriority
#else
    import AppKit
    typealias LayoutAttribute = NSLayoutConstraint.Attribute
    typealias LayoutRelation = NSLayoutConstraint.Relation
    typealias LayoutPriority = NSLayoutConstraint.Priority
#endif
