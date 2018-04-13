//
//  XYAnchor.swift
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

class XYAnchor {
    enum Kind {
        case center
        #if os(iOS)
        case centerWithinMargins
        #else
        // used to remove warning in switch statement from macOS target
        case unhandled
        #endif
        case topLeft
        case bottomRight
    }
    
    let x: Anchor<XAxis>
    let y: Anchor<YAxis>
    let kind: Kind

    init(target: Anchorable, kind: Kind) {
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
