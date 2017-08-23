//
//  Anchor
//  Slate
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

#if os(iOS)
    import UIKit
    typealias View = UIView
#else
    import AppKit
    typealias View = NSView
#endif

fileprivate let DSLConstraintIdentifier = "DSLConstraint"

private var storedConstraints: [NSLayoutConstraint]?

/// Returns all constraints constructed in closure, uses a global, not thread-safe.
/// Run on main thread only!
func captureConstraints(constructedInClosure closure: () -> Void) -> [NSLayoutConstraint] {
    assert(Thread.isMainThread)
    
    storedConstraints = [NSLayoutConstraint]()
    closure()
    
    guard let stored = storedConstraints else {
        assertionFailure("storedConstraints unexpectedly nil")
        return []
    }
    
    storedConstraints = nil
    return stored
}


class Anchor<Kind> where Kind: AnchorType {
    enum TargetType {
        case view(_: UIView)
        case layoutSupport(_: UILayoutSupport)
    }
    
    let target: TargetType
    var innerTarget: Any {
        switch target {
        case let .view(view):
            return view
        case let .layoutSupport(layoutSupport):
            return layoutSupport
        }
    }
    
    let attribute: NSLayoutAttribute
    
    init(target: View, kind attribute: NSLayoutAttribute) {
        self.target = .view(target)
        self.attribute = attribute
    }
    
    init(target: UILayoutSupport, kind attribute: NSLayoutAttribute) {
        self.target = .layoutSupport(target)
        self.attribute = attribute
    }
    
    @discardableResult func pin(to: Anchor<Kind>,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .equal, add: add, rank: rank)
    }
    
    @discardableResult func pin(to view: View,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        let to = Anchor<Kind>(target: view, kind: attribute)
        return pin(to: to, add: add, rank: rank)
    }
    
    @discardableResult func pin(atLeast to: Anchor<Kind>,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .greaterThanOrEqual, add: add, rank: rank)
    }
    
    @discardableResult func pin(atLeast view: View,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        let to = Anchor<Kind>(target: view, kind: attribute)
        return pin(atLeast: to, add: add, rank: rank)
    }
    
    @discardableResult func pin(atMost to: Anchor<Kind>,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .lessThanOrEqual, add: add, rank: rank)
    }
    
    @discardableResult func pin(atMost view: View,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        let to = Anchor<Kind>(target: view, kind: attribute)
        return pin(atMost: to, add: add, rank: rank)
    }
    
    private func pin(to: Anchor<Kind>,
                     relation: NSLayoutRelation, add: CGFloat,
                     rank: Priority?) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(item: innerTarget,
                                            attribute: attribute,
                                            relatedBy: relation,
                                            toItem: to.innerTarget,
                                            attribute: to.attribute,
                                            multiplier: 1,
                                            constant: add)
        configure(constraint: constraint, rank: rank)
        return constraint
        
    }
    
    func configure(constraint: NSLayoutConstraint, rank rankMaybe: Priority?) {
        prepareLeftHandSideForAutoLayout()
        if let rank = rankMaybe {
            constraint.priority = rank.rawValue
        }
        constraint.identifier = DSLConstraintIdentifier
        constraint.isActive = true
        storedConstraints?.append(constraint)
    }
    
    func prepareLeftHandSideForAutoLayout() {
        if case let .view(view) = target {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // MARK: - Removal
    
    @discardableResult
    func removeExisting() -> Bool {
        guard case let .view(view) = target else {
            return false
        }
        guard let existingConstraints = existingDSLConstraint(inView: view,
                                                              target: view,
                                                              attribute: attribute) else {
                                                                return false
        }
        NSLayoutConstraint.deactivate(existingConstraints)
        return true
    }
    
    var existing: NSLayoutConstraint? {
        guard case let .view(view) = target else {
            return nil
        }
        guard let constraints = existingDSLConstraint(inView: view,
                                                      target: view,
                                                      attribute: attribute),
            constraints.count > 0 else {
                return nil
        }
        
        return constraints.first
    }
    
    /// Returns the first constraints it finds matching the attributes. Keeps going up
    /// the view hiearchy until it finds at least one.
    private func existingDSLConstraint(inView view: View,
                                       target: View,
                                       attribute: NSLayoutAttribute) -> [NSLayoutConstraint]? {
        let constraints = view.constraints.filter {
            guard ($0.firstItem === target && $0.firstAttribute == attribute) ||
                ($0.secondItem === target  && $0.secondAttribute == attribute) else {
                    return false
            }
            
            guard $0.identifier == DSLConstraintIdentifier else {
                return false
            }
            
            return true
        }
        
        if constraints.count > 0 {
            return constraints
        }
        
        guard let superview = view.superview else {
            print("Unable to find DSL constraint for attribute: \(attribute)")
            return nil
        }
        
        return existingDSLConstraint(inView: superview,
                                     target: target,
                                     attribute: attribute)
    }
    
}

class AnchorType {}
class XAxis: AnchorType {}
class YAxis: AnchorType {}
class Dimension: AnchorType {}

class DimensionAnchor: Anchor<Dimension> {
    
    @discardableResult func pin(to: CGFloat,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .equal, rank: rank)
    }
    
    @discardableResult func pin(atLeast to: CGFloat,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .greaterThanOrEqual, rank: rank)
    }
    
    @discardableResult func pin(atMost to: CGFloat,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .greaterThanOrEqual, rank: rank)
    }
    
    @discardableResult func pin(to: DimensionAnchor,
                                add: CGFloat = 0,
                                times: CGFloat,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .equal, add: add, times: times, rank: rank)
    }
    
    @discardableResult func pin(to view: View,
                                add: CGFloat = 0,
                                times: CGFloat,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        let to = DimensionAnchor(target: view, kind: attribute)
        return pin(to: to, add: add, times: times, rank: rank)
    }
    
    @discardableResult func pin(atLeast to: DimensionAnchor,
                                add: CGFloat = 0,
                                times: CGFloat,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .greaterThanOrEqual, add: add, times: times, rank: rank)
    }
    
    @discardableResult func pin(atLeast view: View,
                                add: CGFloat = 0,
                                times: CGFloat,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        let to = DimensionAnchor(target: view, kind: attribute)
        return pin(atLeast: to, add: add, times: times, rank: rank)
    }
    
    @discardableResult func pin(atMost to: DimensionAnchor,
                                add: CGFloat = 0,
                                times: CGFloat,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        return pin(to: to, relation: .lessThanOrEqual, add: add, times: times, rank: rank)
    }
    
    @discardableResult func pin(atMost view: View,
                                add: CGFloat = 0,
                                times: CGFloat,
                                rank: Priority? = nil) -> NSLayoutConstraint {
        let to = DimensionAnchor(target: view, kind: attribute)
        return pin(atMost: to, add: add, times: times, rank: rank)
    }
    
    private func pin(to: DimensionAnchor,
                     relation: NSLayoutRelation, add: CGFloat, times: CGFloat,
                     rank: Priority?) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: innerTarget,
                                            attribute: attribute,
                                            relatedBy: relation,
                                            toItem: to.innerTarget,
                                            attribute: to.attribute,
                                            multiplier: times,
                                            constant: add)
        configure(constraint: constraint, rank: rank)
        return constraint
        
    }
    
    private func pin(to: CGFloat,
                     relation: NSLayoutRelation,
                     rank: Priority?) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: innerTarget,
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
        #if os(iOS)
        case centerWithinMargins
        #else
        // used to remove warning in swithc statement from macOS target
        case unhandled
        #endif
        case topLeft
        case bottomRight
    }
    
    let x: Anchor<XAxis>
    let y: Anchor<YAxis>
    let kind: Kind
    
    init(target: View, kind: Kind) {
        self.kind = kind
        
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
        default:
            #if os(iOS)
                if kind == .centerWithinMargins {
                    x = target.centerXWithinMargins
                    y = target.centerYWithinMargins
                    break
                }
            #endif
            fatalError("Unhandled XY anchor kind!")
        }
    }
    
    @discardableResult func pin(to: XYAnchor,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        let xConstraint = x.pin(to: to.x, add: add, rank: rank)
        let yConstraint = y.pin(to: to.y, add: add, rank: rank)
        
        return [xConstraint, yConstraint]
    }
    
    @discardableResult func pin(atLeast to: XYAnchor,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        let xConstraint = x.pin(atLeast: to.x, add: add, rank: rank)
        let yConstraint = y.pin(atLeast: to.y, add: add, rank: rank)
        
        return [xConstraint, yConstraint]
    }
    
    @discardableResult func pin(atMost to: XYAnchor,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        let xConstraint = x.pin(atMost: to.x, add: add, rank: rank)
        let yConstraint = y.pin(atMost: to.y, add: add, rank: rank)
        
        return [xConstraint, yConstraint]
    }
    
}

class SizeAnchor {
    let width: DimensionAnchor
    let height: DimensionAnchor
    
    init(target: View) {
        width = target.width
        height = target.height
    }
    
    @discardableResult func pin(to: SizeAnchor,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        let widthConstraint = width.pin(to: to.width, add: add, rank: rank)
        let heightConstraint = height.pin(to: to.height, add: add, rank: rank)
        
        return [widthConstraint, heightConstraint]
    }
    
    @discardableResult func pin(to: CGSize,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        let widthConstraint = width.pin(to: to.width + add, rank: rank)
        let heightConstraint = height.pin(to: to.height + add, rank: rank)
        
        return [widthConstraint, heightConstraint]
    }
    
    @discardableResult func pin(atLeast to: SizeAnchor,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        let widthConstraint = width.pin(atLeast: to.width, add: add, rank: rank)
        let heightConstraint = height.pin(atLeast: to.height, add: add, rank: rank)
        
        return [widthConstraint, heightConstraint]
    }
    
    @discardableResult func pin(atMost to: SizeAnchor,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        let widthConstraint = width.pin(atMost: to.width, add: add, rank: rank)
        let heightConstraint = height.pin(atMost: to.height, add: add, rank: rank)
        
        return [widthConstraint, heightConstraint]
    }
    
}

class EdgesAnchor {
    
    let topLeft: XYAnchor
    let bottomRight: XYAnchor
    
    init(target: View) {
        topLeft = XYAnchor(target: target, kind: .topLeft)
        bottomRight = XYAnchor(target: target, kind: .bottomRight)
    }
    
    @discardableResult func pin(to: EdgesAnchor,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        
        return topLeft.pin(to: to.topLeft, add: add, rank: rank) +
            bottomRight.pin(to: to.bottomRight, add: add, rank: rank)
    }
    
    @discardableResult func pin(atLeast to: EdgesAnchor,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        return topLeft.pin(atLeast: to.topLeft, add: add, rank: rank) +
            bottomRight.pin(atLeast: to.bottomRight, add: add, rank: rank)
    }
    
    @discardableResult func pin(atMost to: EdgesAnchor,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        return topLeft.pin(atMost: to.topLeft, add: add, rank: rank) +
            bottomRight.pin(atMost: to.bottomRight, add: add, rank: rank)
    }
    
}
