//
//  AnchorProxies.swift
//  Slate
//
//  Created by John Coates on 6/6/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable force_cast identifier_name

import UIKit

class AnyCoreLayout<L: CoreLayout> {
    private let inner: L
    init(_ inner: L) {
        self.inner = inner
    }
    
    func constrain(to: AnyCoreLayout<L>, add: CGFloat,
                   priority priorityMaybe: FixedLayoutPriority?) -> NSLayoutConstraint {
        let anchor = inner.constraint(equalTo: to.inner as! NSLayoutAnchor<L.AnchorType>,
                                      constant: add)
        if let priority = priorityMaybe {
            anchor.priority = priority.rawValue
        }
        anchor.isActive = true
        return anchor
    }
}

class AnyCoreDimensionLayout: AnyCoreLayout<NSLayoutDimension> {
    private let innerDimension: NSLayoutDimension
    override init(_ inner: NSLayoutDimension) {
        self.innerDimension = inner
        super.init(inner)
    }
    
    func constrain(to: CGFloat, priority priorityMaybe: FixedLayoutPriority?) -> NSLayoutConstraint {
        let anchor = innerDimension.constraint(equalToConstant: to)
        if let priority = priorityMaybe {
            anchor.priority = priority.rawValue
        }
        anchor.isActive = true
        return anchor
    }
}
