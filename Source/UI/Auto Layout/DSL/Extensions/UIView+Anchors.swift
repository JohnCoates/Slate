//
//  UIView+Anchors.swift
//  Slate
//
//  Created by John Coates on 6/5/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

extension View {
    var left: Anchor<XAxis> {
        return Anchor<XAxis>(target: self, kind: .left)
    }
    
    var right: Anchor<XAxis> {
        return Anchor<XAxis>(target: self, kind: .right)
    }
    
    var top: Anchor<YAxis> {
        return Anchor<YAxis>(target: self, kind: .top)
    }
    
    var bottom: Anchor<YAxis> {
        return Anchor<YAxis>(target: self, kind: .bottom)
    }
    
    var width: DimensionAnchor {
        return DimensionAnchor(target: self, kind: .width)
    }
    
    var height: DimensionAnchor {
        return DimensionAnchor(target: self, kind: .height)
    }
    
    var size: SizeAnchor {
        return SizeAnchor(target: self)
    }
    
    var centerX: Anchor<XAxis> {
        return Anchor<XAxis>(target: self, kind: .centerX)
    }
    
    var centerY: Anchor<YAxis> {
        return Anchor<YAxis>(target: self, kind: .centerY)
    }
    
    var centerXY: XYAnchor {
        return XYAnchor(target: self, kind: .center)
    }
    
    var leading: Anchor<XAxis> {
        return Anchor<XAxis>(target: self, kind: .leading)
    }
    
    var trailing: Anchor<XAxis> {
        return Anchor<XAxis>(target: self, kind: .trailing)
    }
    
    var baseline: Anchor<YAxis> {
        return lastBaseline
    }
    
    var firstBaseline: Anchor<YAxis> {
        return Anchor<YAxis>(target: self, kind: .firstBaseline)
    }
    
    var lastBaseline: Anchor<YAxis> {
        return Anchor<YAxis>(target: self, kind: .lastBaseline)
    }
    
    var edges: EdgesAnchor {
        return EdgesAnchor(target: self)
    }
    
    var anchors: ViewAnchorGenerator {
        return ViewAnchorGenerator(view: self)
    }
    
    // MARK: - Margins, iOS only
    
    #if os(iOS)
    
    var leftMargin: Anchor<XAxis> {
        return Anchor<XAxis>(target: self, kind: .leftMargin)
    }
    
    var rightMargin: Anchor<XAxis> {
        return Anchor<XAxis>(target: self, kind: .rightMargin)
    }
    
    var topMargin: Anchor<YAxis> {
        return Anchor<YAxis>(target: self, kind: .topMargin)
    }
    
    var bottomMargin: Anchor<YAxis> {
        return Anchor<YAxis>(target: self, kind: .bottomMargin)
    }
    
    var centerXWithinMargins: Anchor<XAxis> {
        return Anchor<XAxis>(target: self, kind: .centerXWithinMargins)
    }
    
    var centerYWithinMargins: Anchor<YAxis> {
        return Anchor<YAxis>(target: self, kind: .centerYWithinMargins)
    }
    
    var centerXYWithinMargins: XYAnchor {
        return XYAnchor(target: self, kind: .centerWithinMargins)
    }
    
    #endif
}

// MARK: - View Anchors

struct ViewAnchorGenerator {
    let view: View
    
    init(view: View) {
        self.view = view
    }
    
    subscript(attribute: NSLayoutAttribute...) -> ViewAnchors {
        return ViewAnchors(view: view, attributes: attribute)
    }
}

struct ViewAnchors {
    let view: View
    let attributes: [NSLayoutAttribute]
    
    init(view: View, attributes: [NSLayoutAttribute]) {
        self.view = view
        self.attributes = attributes
    }
}
