//
//  UIView+Anchors.swift
//  Slate
//
//  Created by John Coates on 6/5/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

extension UIView {
    var left2: Anchor<XAxis> {
        return Anchor<XAxis>(target: self, kind: .left)
    }
    
    var right2: Anchor<XAxis> {
        return Anchor<XAxis>(target: self, kind: .right)
    }
    
    var top2: Anchor<YAxis> {
        return Anchor<YAxis>(target: self, kind: .top)
    }
    
    var bottom2: Anchor<YAxis> {
        return Anchor<YAxis>(target: self, kind: .bottom)
    }
    
    var width2: DimensionAnchor {
        return DimensionAnchor(target: self, kind: .width)
    }
    
    var height2: DimensionAnchor {
        return DimensionAnchor(target: self, kind: .height)
    }
    
    var centerX2: Anchor<XAxis> {
        return Anchor<XAxis>(target: self, kind: .centerX)
    }
    
    var centerY2: Anchor<YAxis> {
        return Anchor<YAxis>(target: self, kind: .centerY)
    }
    
    var centerXY2: XYAnchor {
        return XYAnchor(target: self, kind: .center)
    }
    
    var bottomMargin: Anchor<YAxis> {
        return Anchor<YAxis>(target: self, kind: .bottomMargin)
    }
    
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
    
    var centerXY: LayoutXYAnchor {
        return LayoutXYAnchor(target: self, kind: .center)
    }
}
