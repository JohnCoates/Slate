//
//  Anchorable
//  Created on 4/13/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

protocol Anchorable {
    var anchorTarget: AnchorTarget { get }
}

extension Anchorable {
    var left: Anchor<XAxis> {
        return Anchor<XAxis>(target: anchorTarget, kind: .left)
    }

    var right: Anchor<XAxis> {
        return Anchor<XAxis>(target: anchorTarget, kind: .right)
    }

    var top: Anchor<YAxis> {
        return Anchor<YAxis>(target: anchorTarget, kind: .top)
    }

    var bottom: Anchor<YAxis> {
        return Anchor<YAxis>(target: anchorTarget, kind: .bottom)
    }

    var width: DimensionAnchor {
        return DimensionAnchor(target: anchorTarget, kind: .width)
    }

    var height: DimensionAnchor {
        return DimensionAnchor(target: anchorTarget, kind: .height)
    }

    var size: SizeAnchor {
        return SizeAnchor(target: self)
    }

    var centerX: Anchor<XAxis> {
        return Anchor<XAxis>(target: anchorTarget, kind: .centerX)
    }

    var centerY: Anchor<YAxis> {
        return Anchor<YAxis>(target: anchorTarget, kind: .centerY)
    }

    var centerXY: XYAnchor {
        return XYAnchor(target: self, kind: .center)
    }

    var leading: Anchor<XAxis> {
        return Anchor<XAxis>(target: anchorTarget, kind: .leading)
    }

    var trailing: Anchor<XAxis> {
        return Anchor<XAxis>(target: anchorTarget, kind: .trailing)
    }

    var baseline: Anchor<YAxis> {
        return lastBaseline
    }

    var firstBaseline: Anchor<YAxis> {
        return Anchor<YAxis>(target: anchorTarget, kind: .firstBaseline)
    }

    var lastBaseline: Anchor<YAxis> {
        return Anchor<YAxis>(target: anchorTarget, kind: .lastBaseline)
    }

    var edges: EdgesAnchor {
        return EdgesAnchor(target: self)
    }

    var anchors: LayoutAnchorGenerator {
        return LayoutAnchorGenerator(target: anchorTarget)
    }

    // MARK: - Margins, iOS only

    #if os(iOS)

    var leftMargin: Anchor<XAxis> {
        return Anchor<XAxis>(target: anchorTarget, kind: .leftMargin)
    }

    var rightMargin: Anchor<XAxis> {
        return Anchor<XAxis>(target: anchorTarget, kind: .rightMargin)
    }

    var topMargin: Anchor<YAxis> {
        return Anchor<YAxis>(target: anchorTarget, kind: .topMargin)
    }

    var bottomMargin: Anchor<YAxis> {
        return Anchor<YAxis>(target: anchorTarget, kind: .bottomMargin)
    }

    var leadingMargin: Anchor<XAxis> {
        return Anchor<XAxis>(target: anchorTarget, kind: .leadingMargin)
    }

    var trailingMargin: Anchor<XAxis> {
        return Anchor<XAxis>(target: anchorTarget, kind: .trailingMargin)
    }

    var centerXWithinMargins: Anchor<XAxis> {
        return Anchor<XAxis>(target: anchorTarget, kind: .centerXWithinMargins)
    }

    var centerYWithinMargins: Anchor<YAxis> {
        return Anchor<YAxis>(target: anchorTarget, kind: .centerYWithinMargins)
    }

    var centerXYWithinMargins: XYAnchor {
        return XYAnchor(target: self, kind: .centerWithinMargins)
    }

    #endif
}
