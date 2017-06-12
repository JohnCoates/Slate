//
//  DBAttribute.swift
//  Slate
//
//  Created by John Coates on 6/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

enum DBAttributeType {
    case int16
    case int32
    case int64
    case decimal
    case double
    case float
    case string
    case boolean
    case date
    case binary
    case transformable
    case objectID
    
    var coreType: NSAttributeType {
        switch self {
        case .int16:
            return .integer16AttributeType
        case .int32:
            return .integer32AttributeType
        case .int64:
            return .integer64AttributeType
        case .decimal:
            return .decimalAttributeType
        case .double:
            return .doubleAttributeType
        case .float:
            return .floatAttributeType
        case .string:
            return .stringAttributeType
        case .boolean:
            return .booleanAttributeType
        case .date:
            return .dateAttributeType
        case .binary:
            return .binaryDataAttributeType
        case .transformable:
            return .transformableAttributeType
        case .objectID:
            return .objectIDAttributeType
        }
    }
}
