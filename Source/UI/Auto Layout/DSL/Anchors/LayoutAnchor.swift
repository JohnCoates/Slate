//
//  LayoutAnchor.swift
//  Slate
//
//  Created by John Coates on 6/5/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable force_cast

import UIKit

class LayoutAnchor<AnchorType> where AnchorType: AnyObject, AnchorType: CoreLayout {
    typealias AnchorType2 = NSLayoutAnchor<AnchorType>
    enum Kind {
        case left
        case right
        case top
        case bottom
        case width
        case height
        case centerY
        case centerX
        case leading
        case trailing
        case firstBaseline
        case lastBaseline
    }
    
    let target: UIView
    let kind: Kind
    lazy var proxy: AnyCoreLayout<AnchorType>  = {
        return AnyCoreLayout<AnchorType>(self.coreRepresentative)
    }()
    
    init(target: UIView, kind: Kind) {
        self.target = target
        self.kind = kind
    }
    
    @discardableResult func pin(to: LayoutAnchor<AnchorType>,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        prepareLeftHandSideForAutoLayout()
        return proxy.constrain(to: to.proxy, add: add, priority: rank)
    }
    
    @discardableResult func pin(atLeast to: LayoutAnchor<AnchorType>,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        prepareLeftHandSideForAutoLayout()
        return proxy.constrain(atLeast: to.proxy, add: add, priority: rank)
    }
    
    func prepareLeftHandSideForAutoLayout() {
        target.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var coreRepresentative: AnchorType {
        switch kind {
        case .left:
            return target.leftAnchor as! AnchorType
        case .right:
            return target.rightAnchor as! AnchorType
        case .top:
            return target.topAnchor as! AnchorType
        case .bottom:
            return target.bottomAnchor as! AnchorType
        case .width:
            return target.widthAnchor as! AnchorType
        case .height:
            return target.heightAnchor as! AnchorType
        case .centerY:
            return target.centerYAnchor as! AnchorType
        case .centerX:
            return target.centerXAnchor as! AnchorType
        case .leading:
            return target.leadingAnchor as! AnchorType
        case .trailing:
            return target.trailingAnchor as! AnchorType
        case .firstBaseline:
            return target.firstBaselineAnchor as! AnchorType
        case .lastBaseline:
            return target.lastBaselineAnchor as! AnchorType
        }
    }
}

class LayoutDimensionAnchor: LayoutAnchor<NSLayoutDimension> {
    
    lazy var dimensionProxy: AnyCoreDimensionLayout = {
        return AnyCoreDimensionLayout(self.coreRepresentative)
    }()
    
    @discardableResult func pin(to: LayoutDimensionAnchor,
                                add: CGFloat = 0,
                                times: CGFloat,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = dimensionProxy.constrain(to: to.dimensionProxy,
                                                  add: add, times: times, priority: rank)
        return constraint
    }
    
    @discardableResult func pin(to: CGFloat,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = dimensionProxy.constrain(to: to, priority: rank)
        return constraint
    }
    
    @discardableResult func pin(atLeast to: CGFloat,
                                rank: FixedLayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = dimensionProxy.constrain(atLeast: to, priority: rank)
        return constraint
    }
    
    
}

class LayoutXYAnchor {
    enum Kind {
        case position
        case center
    }
    
    let xAnchor: LayoutAnchor<NSLayoutXAxisAnchor>
    let yAnchor: LayoutAnchor<NSLayoutYAxisAnchor>
    
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
    
    @discardableResult func pin(to: LayoutXYAnchor,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> [NSLayoutConstraint] {
        let xConstraint = xAnchor.pin(to: to.xAnchor, add: add, rank: rank)
        let yConstraint = yAnchor.pin(to: to.yAnchor, add: add, rank: rank)
        
        return [xConstraint, yConstraint]
    }
    
    @discardableResult func pin(atLeast to: LayoutXYAnchor,
                                add: CGFloat = 0,
                                rank: FixedLayoutPriority? = nil) -> [NSLayoutConstraint] {
        let xConstraint = xAnchor.pin(atLeast: to.xAnchor, add: add, rank: rank)
        let yConstraint = yAnchor.pin(atLeast: to.yAnchor, add: add, rank: rank)
        
        return [xConstraint, yConstraint]
    }
   
}
