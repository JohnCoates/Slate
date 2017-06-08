//
//  CGPoint.swift
//  Slate
//
//  Created by John Coates on 6/3/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation

extension DrawProxyDSL {
    struct CGPoint {
        let x: Float
        let y: Float
        
        var point: Path.Point {
            return Path.Point(x: self.x, y: self.y)
        }
    }
}
