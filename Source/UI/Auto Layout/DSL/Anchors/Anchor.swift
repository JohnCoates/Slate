//
//  Anchor
//  Slate
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable identifier_name

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
        return pin(to: to, relation: .equal, add: add, rank: rank)
    }
    
    @discardableResult func pin(atLeast to: Anchor<Kind>,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .greaterThanOrEqual, add: add, rank: rank)
    }
    
    @discardableResult func pin(atMost to: Anchor<Kind>,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .lessThanOrEqual, add: add, rank: rank)
    }
    
    private func pin(to: Anchor<Kind>,
                     relation: NSLayoutRelation, add: CGFloat,
                     rank: FixedLayoutPriority?) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: target,
                                            attribute: attribute,
                                            relatedBy: relation,
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
        return pin(to: to, relation: .equal, rank: rank)
    }
    
    @discardableResult func pin(atLeast to: CGFloat,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .greaterThanOrEqual, rank: rank)
    }
    
    @discardableResult func pin(atMost to: CGFloat,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .greaterThanOrEqual, rank: rank)
    }
    
    @discardableResult func pin(to: DimensionAnchor,
                                add: CGFloat = 0,
                                times: CGFloat,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .equal, add: add, times: times, rank: rank)
    }
    
    @discardableResult func pin(atLeast to: DimensionAnchor,
                                add: CGFloat = 0,
                                times: CGFloat,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .greaterThanOrEqual, add: add, times: times, rank: rank)
    }
    
    @discardableResult func pin(atMost to: DimensionAnchor,
                                add: CGFloat = 0,
                                times: CGFloat,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .lessThanOrEqual, add: add, times: times, rank: rank)
    }
    
    private func pin(to: DimensionAnchor,
                     relation: NSLayoutRelation, add: CGFloat, times: CGFloat,
                     rank: FixedLayoutPriority?) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: target,
                                            attribute: attribute,
                                            relatedBy: relation,
                                            toItem: to.target,
                                            attribute: to.attribute,
                                            multiplier: times,
                                            constant: add)
        configure(constraint: constraint, rank: rank)
        return constraint
        
    }
    
    private func pin(to: CGFloat,
                     relation: NSLayoutRelation,
                     rank: FixedLayoutPriority?) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: target,
                                            attribute: attribute,
                                            relatedBy: relation,
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
        case center
        case topLeft
        case bottomRight
    }
    
    let x: Anchor<XAxis>
    let y: Anchor<YAxis>
    
    init(target: UIView, kind: Kind) {
        switch kind {
        case .center:
            x = target.centerX
            y = target.centerY
        case .topLeft:
            x = target.left
            y = target.top
        case .bottomRight:
            x = target.right
            y = target.bottom
        }
    }
    
    @discardableResult func pin(to: XYAnchor,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> [NSLayoutConstraint] {
        let xConstraint = x.pin(to: to.x, add: add, rank: rank)
        let yConstraint = y.pin(to: to.y, add: add, rank: rank)
        
        return [xConstraint, yConstraint]
    }
    
    @discardableResult func pin(atLeast to: XYAnchor,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> [NSLayoutConstraint] {
        let xConstraint = x.pin(atLeast: to.x, add: add, rank: rank)
        let yConstraint = y.pin(atLeast: to.y, add: add, rank: rank)
        
        return [xConstraint, yConstraint]
    }
    
    @discardableResult func pin(atMost to: XYAnchor,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> [NSLayoutConstraint] {
        let xConstraint = x.pin(atMost: to.x, add: add, rank: rank)
        let yConstraint = y.pin(atMost: to.y, add: add, rank: rank)
        
        return [xConstraint, yConstraint]
    }
}

class SizeAnchor {
    let width: DimensionAnchor
    let height: DimensionAnchor
    
    init(target: UIView) {
        width = target.width
        height = target.height
    }
    
    @discardableResult func pin(to: SizeAnchor,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> [NSLayoutConstraint] {
        let widthConstraint = width.pin(to: to.width, add: add, rank: rank)
        let heightConstraint = height.pin(to: to.height, add: add, rank: rank)
        
        return [widthConstraint, heightConstraint]
    }
    
    @discardableResult func pin(atLeast to: SizeAnchor,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> [NSLayoutConstraint] {
        let widthConstraint = width.pin(atLeast: to.width, add: add, rank: rank)
        let heightConstraint = height.pin(atLeast: to.height, add: add, rank: rank)
        
        return [widthConstraint, heightConstraint]
    }
    
    @discardableResult func pin(atMost to: SizeAnchor,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> [NSLayoutConstraint] {
        let widthConstraint = width.pin(atMost: to.width, add: add, rank: rank)
        let heightConstraint = height.pin(atMost: to.height, add: add, rank: rank)
        
        return [widthConstraint, heightConstraint]
    }
}

class EdgesAnchor {
    
    let topLeft: XYAnchor
    let bottomRight: XYAnchor
    
    init(target: UIView) {
        topLeft = XYAnchor(target: target, kind: .topLeft)
        bottomRight = XYAnchor(target: target, kind: .bottomRight)
    }
    
    @discardableResult func pin(to: EdgesAnchor,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> [NSLayoutConstraint] {
        
        return topLeft.pin(to: to.topLeft, add: add, rank: rank) +
               bottomRight.pin(to: to.bottomRight, add: add, rank: rank)
    }
    
    @discardableResult func pin(atLeast to: EdgesAnchor,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> [NSLayoutConstraint] {
        return topLeft.pin(atLeast: to.topLeft, add: add, rank: rank) +
            bottomRight.pin(atLeast: to.bottomRight, add: add, rank: rank)
    }
    
    @discardableResult func pin(atMost to: EdgesAnchor,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> [NSLayoutConstraint] {
        return topLeft.pin(atMost: to.topLeft, add: add, rank: rank) +
            bottomRight.pin(atMost: to.bottomRight, add: add, rank: rank)
    }
}
