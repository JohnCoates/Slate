//
//  Writer+Data.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension VectorAssetWriter {
    
    func append(point: DataPoint) {
        append(uInt16: point.xIndex)
        append(uInt16: point.yIndex)
    }
    
    func append(rect: DataRect) {
        append(uInt16: rect.xIndex)
        append(uInt16: rect.yIndex)
        append(uInt16: rect.widthIndex)
        append(uInt16: rect.heightIndex)
    }
    
    func append(nullTerminatedString string: String) {
        let value = string.cString(using: .utf8)
        let bytes = string.lengthOfBytes(using: .utf8) + 1
        data.append(UnsafeBufferPointer(start: value, count: bytes))
    }
    
    func append(uInt8 constValue: UInt8) {
        append(value: constValue)
    }
    
    func append(uInt16 constValue: UInt16) {
        append(value: constValue)
    }
    
    func append<DataType>(value constValue: DataType) {
        var value: DataType = constValue
        let buffer = UnsafeBufferPointer(start: &value, count: 1)
        data.append(buffer)
    }
    
}
