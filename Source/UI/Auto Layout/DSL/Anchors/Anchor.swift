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

private let DSLConstraintIdentifier = "DSLConstraint"

class AnchorType {}
class XAxis: AnchorType {}
class YAxis: AnchorType {}
class Dimension: AnchorType {}

class Anchor<Kind> where Kind: AnchorType {
    #if os(iOS)
    enum TargetType {
        case view(_: View)
        case layoutSupport(_: UILayoutSupport)
    }
    #else
    enum TargetType {
        case view(_: View)
    }
    #endif
    
    let target: TargetType
    var innerTarget: Any {
        #if os(iOS)
        switch target {
        case let .view(view):
            return view
        case let .layoutSupport(layoutSupport):
            return layoutSupport
        }
        #else
        switch target {
        case let .view(view):
            return view
        }
        #endif
    }
    
    let attribute: LayoutAttribute
    
    init(target: View, kind attribute: LayoutAttribute) {
        self.target = .view(target)
        self.attribute = attribute
    }
    
    #if os(iOS)
    init(target: UILayoutSupport, kind attribute: LayoutAttribute) {
        self.target = .layoutSupport(target)
        self.attribute = attribute
    }
    #endif
    
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
                     relation: LayoutRelation, add: CGFloat,
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
            var isCellContentView = false
            if let superview = view.superview, superview is UITableViewCell {
                isCellContentView = true
            }
            if isCellContentView {
                return
            }
            
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
                                       attribute: LayoutAttribute) -> [NSLayoutConstraint]? {
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

// MARK: - Capturing

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
