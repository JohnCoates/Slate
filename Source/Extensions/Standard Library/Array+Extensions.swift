//
//  Array+Extensions.swift
//  Slate
//
//  Created by John Coates on 6/1/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    var unique: [Element] {
        var values: [Element] = []
        for value in self {
            guard values.contains(value) == false else {
                continue
            }
            values.append(value)
        }
        return values
    }
}
