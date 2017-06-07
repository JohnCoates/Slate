//
//  LayoutAttribute.swift
//  Slate
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class Anchor<Kind> where Kind: AnchorType {
    let target: UIView
    let attribute: NSLayoutAttribute
    init(target: UIView, kind attribute: NSLayoutAttribute) {
        self.target = target
        self.attribute = attribute
    }
    
    @discardableResult func pin(to: Anchor<Kind>,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: target,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: to.target,
                                            attribute: to.attribute,
                                            multiplier: 1,
                                            constant: add)
        configure(constraint: constraint, rank: rank)
        return constraint
    }
    
    @discardableResult func pin(atLeast to: Anchor<Kind>,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: target,
                                            attribute: attribute,
                                            relatedBy: .greaterThanOrEqual,
                                            toItem: to.target,
                                            attribute: to.attribute,
                                            multiplier: 1,
                                            constant: add)
        configure(constraint: constraint, rank: rank)
        return constraint
    }
    
    func configure(constraint: NSLayoutConstraint, rank rankMaybe: FixedLayoutPriority?) {
        prepareLeftHandSideForAutoLayout()
        if let rank = rankMaybe {
            constraint.priority = rank.rawValue
        }
        constraint.isActive = true
    }
    
    func prepareLeftHandSideForAutoLayout() {
        target.translatesAutoresizingMaskIntoConstraints = false
    }
}

class AnchorType { }
class XAxis: AnchorType {}
class YAxis: AnchorType {}
class Dimension: AnchorType {}

class DimensionAnchor: Anchor<Dimension> {
    @discardableResult func pin(to: CGFloat,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: target,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: to)
        configure(constraint: constraint, rank: rank)
        return constraint
    }
    
    @discardableResult func pin(to: DimensionAnchor,
                                add: CGFloat = 0,
                                times: CGFloat,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: target,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: to.target,
                                            attribute: to.attribute,
                                            multiplier: times,
                                            constant: add)
        configure(constraint: constraint, rank: rank)
        return constraint
    }
    
    @discardableResult func pin(atLeast to: CGFloat,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: target,
                                            attribute: attribute,
                                            relatedBy: .greaterThanOrEqual,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: to)
        configure(constraint: constraint, rank: rank)
        return constraint
    }
}

class XYAnchor {
    enum Kind {
        case position
        case center
    }
    
    let xAnchor: Anchor<XAxis>
    let yAnchor: Anchor<YAxis>
    
    init(target: UIView, kind: Kind) {
        switch kind {
        case .center:
            xAnchor = target.centerX
            yAnchor = target.centerY
        case .position:
            xAnchor = target.left
            yAnchor = target.top
        }
    }
    
    @discardableResult func pin(to: XYAnchor,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> [NSLayoutConstraint] {
        let xConstraint = xAnchor.pin(to: to.xAnchor, add: add, rank: rank)
        let yConstraint = yAnchor.pin(to: to.yAnchor, add: add, rank: rank)
        
        return [xConstraint, yConstraint]
    }
    
    @discardableResult func pin(atLeast to: XYAnchor,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> [NSLayoutConstraint] {
        let xConstraint = xAnchor.pin(atLeast: to.xAnchor, add: add, rank: rank)
        let yConstraint = yAnchor.pin(atLeast: to.yAnchor, add: add, rank: rank)
        
        return [xConstraint, yConstraint]
    }
    
}
