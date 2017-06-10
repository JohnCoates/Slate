//
//  CGRect.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension DrawProxyDSL {
    struct CGRect {
        let x: Float
        let y: Float
        let width: Float
        let height: Float
        var rect: Path.Rect {
            return Path.Rect(origin: Path.Point(x: x, y: y),
                             size: Path.Point(x: width, y: height))
        }
    }
}
