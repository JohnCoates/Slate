//
//  Float.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

struct DataFloat: CustomStringConvertible, Equatable {
    let value: Float
    let index: UInt16
    
    var description: String {
        return "[DataFloat \(value), index: \(index)]"
    }
}

// MARK: - Colors

func == (lhs: DataFloat, rhs: DataFloat) -> Bool {
    return lhs.value == rhs.value
}

func == (lhs: Float, rhs: DataFloat) -> Bool {
    return lhs == rhs.value
}
