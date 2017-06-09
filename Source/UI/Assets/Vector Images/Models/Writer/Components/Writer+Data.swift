//
//  Writer+Data.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension VectorImage.Writer {
    
    func append(point: DataPoint) {
        append(uInt16: point.xIndex)
        append(uInt16: point.yIndex)
    }
    
    func append(nullTerminatedString string: String) {
        let value = string.cString(using: .utf8)
        let bytes = string.lengthOfBytes(using: .utf8) + 1
        print("appending string with bytes: \(bytes)")
        data.append(UnsafeBufferPointer(start: value, count: bytes))
    }
    
    func append(uInt8 constValue: UInt8) {
        var value = constValue
        data.append(UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func append(uInt16 constValue: UInt16) {
        var value = constValue
        data.append(UnsafeBufferPointer(start: &value, count: 1))
    }
}
