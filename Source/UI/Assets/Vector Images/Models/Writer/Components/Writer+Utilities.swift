//
//  Writer+Utilities.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension VectorAssetWriter {
    
    func sectionIndex(forSection section: String) -> UInt16 {
        guard let index = sections.firstIndex(of: section) else {
            fatalError("Couldn't find section \(section) in sections: \(sections)")
        }
        return UInt16(index)
    }
    
    func index(forFloat float: Float) -> UInt16 {
        guard let index = floats.firstIndex(where: { $0.value == float }) else {
            fatalError("Couldn't find float value: \(float) in \(floats)!")
        }
        let value = floats[index]
        return value.index
    }
    
    func add(point: Path.Point, toFloats floats: inout [Float]) {
        add(floats: [point.x, point.y], toFloats: &floats)
    }
    
    func add(color: Path.Color, toFloats floats: inout [Float]) {
        add(floats: [color.red, color.green, color.blue, color.alpha], toFloats: &floats)
    }
    
    func add(floats inFloats: [Float], toFloats floats: inout [Float]) {
        for float in inFloats {
            if !floats.contains(float) {
                floats.append(float)
            }
        }
    }
    
}
