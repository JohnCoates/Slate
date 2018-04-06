//
//  DimensionAnchor.swift
//  Slate
//
//  Created by John Coates on 8/23/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

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
                     relation: LayoutRelation, add: CGFloat, times: CGFloat,
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
                     relation: LayoutRelation,
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
