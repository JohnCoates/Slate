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
