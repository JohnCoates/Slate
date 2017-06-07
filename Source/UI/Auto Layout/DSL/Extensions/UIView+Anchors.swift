//
//  UIView+Anchors.swift
//  Slate
//
//  Created by John Coates on 6/5/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

extension UIView {
    var left: LayoutAnchor<NSLayoutXAxisAnchor> {
        return LayoutAnchor<NSLayoutXAxisAnchor>(target: self, kind: .left)
    }
    
    var right: LayoutAnchor<NSLayoutXAxisAnchor> {
        return LayoutAnchor<NSLayoutXAxisAnchor>(target: self, kind: .right)
    }
    
    var top: LayoutAnchor<NSLayoutYAxisAnchor> {
        return LayoutAnchor<NSLayoutYAxisAnchor>(target: self, kind: .top)
    }
    
    var bottom: LayoutAnchor<NSLayoutYAxisAnchor> {
        return LayoutAnchor<NSLayoutYAxisAnchor>(target: self, kind: .bottom)
    }
    
    var width: LayoutDimensionAnchor {
        return LayoutDimensionAnchor(target: self, kind: .width)
    }
    
    var height: LayoutDimensionAnchor {
        return LayoutDimensionAnchor(target: self, kind: .height)
    }
    
    var centerX: LayoutAnchor<NSLayoutXAxisAnchor> {
        return LayoutAnchor<NSLayoutXAxisAnchor>(target: self, kind: .centerX)
    }
    
    var centerY: LayoutAnchor<NSLayoutYAxisAnchor> {
        return LayoutAnchor<NSLayoutYAxisAnchor>(target: self, kind: .centerY)
    }
    
    var leading: LayoutAnchor<NSLayoutXAxisAnchor> {
        return LayoutAnchor<NSLayoutXAxisAnchor>(target: self, kind: .leading)
    }
    
    var trailing: LayoutAnchor<NSLayoutXAxisAnchor> {
        return LayoutAnchor<NSLayoutXAxisAnchor>(target: self, kind: .trailing)
    }
    
    var baseline: LayoutAnchor<NSLayoutYAxisAnchor> {
        return firstBaseline
    }
    
    var firstBaseline: LayoutAnchor<NSLayoutYAxisAnchor> {
        return LayoutAnchor<NSLayoutYAxisAnchor>(target: self, kind: .firstBaseline)
    }
    
    var lastBaseline: LayoutAnchor<NSLayoutYAxisAnchor> {
        return LayoutAnchor<NSLayoutYAxisAnchor>(target: self, kind: .lastBaseline)
    }
}
