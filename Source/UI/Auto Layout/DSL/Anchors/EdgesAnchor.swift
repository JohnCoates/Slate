//
//  EdgesAnchor.swift
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

class EdgesAnchor {
    
    let topLeft: XYAnchor
    let bottomRight: XYAnchor
    
    init(target: Anchorable) {
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
