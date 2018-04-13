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

extension View: Anchorable {
    var anchorTarget: AnchorTarget {
        return .view(self)
    }
}
