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
    
    func constrain(to: AnyCoreLayout<L>, add: CGFloat = 0,
                   priority priorityMaybe: FixedLayoutPriority?) -> NSLayoutConstraint {
        let constraint = inner.constraint(equalTo: to.inner as! NSLayoutAnchor<L.AnchorType>,
                                      constant: add)
        if let priority = priorityMaybe {
            constraint.priority = priority.rawValue
        }
        constraint.isActive = true
        return constraint
    }
    
    func constrain(atLeast to: AnyCoreLayout<L>, add: CGFloat = 0,
                   priority priorityMaybe: FixedLayoutPriority?) -> NSLayoutConstraint {
        let toAnchor = to.inner as! NSLayoutAnchor<L.AnchorType>
        let constraint = inner.constraint(greaterThanOrEqualTo: toAnchor, constant: add)
        if let priority = priorityMaybe {
            constraint.priority = priority.rawValue
        }
        constraint.isActive = true
        return constraint
    }
}

class AnyCoreDimensionLayout: AnyCoreLayout<NSLayoutDimension> {
    private let innerDimension: NSLayoutDimension
    override init(_ inner: NSLayoutDimension) {
        self.innerDimension = inner
        super.init(inner)
    }
    
    func constrain(to: AnyCoreDimensionLayout, add: CGFloat = 0, times: CGFloat = 1,
                   priority priorityMaybe: FixedLayoutPriority?) -> NSLayoutConstraint {
        let constraint = innerDimension.constraint(equalTo: to.innerDimension,
                                                   multiplier: times, constant: add)
        
        if let priority = priorityMaybe {
            constraint.priority = priority.rawValue
        }
        constraint.isActive = true
        return constraint
    }
    
    func constrain(to: CGFloat,
                   priority priorityMaybe: FixedLayoutPriority?) -> NSLayoutConstraint {
        let constraint = innerDimension.constraint(equalToConstant: to)
        if let priority = priorityMaybe {
            constraint.priority = priority.rawValue
        }
        constraint.isActive = true
        return constraint
    }
    
    func constrain(atLeast to: CGFloat,
                   priority priorityMaybe: FixedLayoutPriority?) -> NSLayoutConstraint {
        let constraint = innerDimension.constraint(greaterThanOrEqualToConstant: to)
        if let priority = priorityMaybe {
            constraint.priority = priority.rawValue
        }
        constraint.isActive = true
        return constraint
    }
}
