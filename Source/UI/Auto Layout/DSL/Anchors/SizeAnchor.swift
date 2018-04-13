//
//  SizeAnchor.swift
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

class SizeAnchor {
    let width: DimensionAnchor
    let height: DimensionAnchor
    
    init(target: Anchorable) {
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
    
    @discardableResult func pin(to: View,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        return pin(to: SizeAnchor(target: to), add: add, rank: rank)
    }
    
    @discardableResult func pin(atLeast to: SizeAnchor,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        let widthConstraint = width.pin(atLeast: to.width, add: add, rank: rank)
        let heightConstraint = height.pin(atLeast: to.height, add: add, rank: rank)
        
        return [widthConstraint, heightConstraint]
    }
    
    @discardableResult func pin(atLeast to: CGSize,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        let widthConstraint = width.pin(atLeast: to.width, rank: rank)
        let heightConstraint = height.pin(atLeast: to.height, rank: rank)
        
        return [widthConstraint, heightConstraint]
    }
    
    @discardableResult func pin(atLeast to: View,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        return pin(atLeast: SizeAnchor(target: to), add: add, rank: rank)
    }
    
    @discardableResult func pin(atMost to: SizeAnchor,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        let widthConstraint = width.pin(atMost: to.width, add: add, rank: rank)
        let heightConstraint = height.pin(atMost: to.height, add: add, rank: rank)
        
        return [widthConstraint, heightConstraint]
    }
    
    @discardableResult func pin(atMost to: CGSize,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        let widthConstraint = width.pin(atMost: to.width, rank: rank)
        let heightConstraint = height.pin(atMost: to.height, rank: rank)
        
        return [widthConstraint, heightConstraint]
    }
    
    @discardableResult func pin(atMost to: View,
                                add: CGFloat = 0,
                                rank: Priority? = nil) -> [NSLayoutConstraint] {
        return pin(atMost: SizeAnchor(target: to), add: add, rank: rank)
    }
    
}
