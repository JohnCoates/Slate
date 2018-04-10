//
//  PhotoResolution.swift
//  Slate
//
//  Created by John Coates on 8/25/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreGraphics

enum PhotoResolution: CustomStringConvertible,
CustomDebugStringConvertible {
    case custom(width: Int, height: Int)
    case maximum
    case notSet
    
    var kind: Int {
        switch self {
        case .custom:
            return 0
        case .maximum:
            return 1
        case .notSet:
            return 2
        }
    }
    
    init(kind: Int, size: CGSize?) {
        switch kind {
        case 0:
            guard let size = size else {
                fatalError("Custom resolution missing size.")
            }
            self = .custom(width: Int(size.width), height: Int(size.height))
        case 1:
            self = .maximum
        case 2:
            self = .notSet
        default:
            fatalError("Unsupported kind for resolution: \(kind)")
        }
    }
    
    var description: String {
        return userFacingDescription
    }
    
    var userFacingDescription: String {
        switch self {
        case let .custom(width, height):
            return "\(width) x \(height)"
        case .maximum:
            return "Maximum"
        case .notSet:
            return "Default"
        }
    }
    
    var debugDescription: String {
        var value: String
        switch self {
        case let .custom(width, height):
            value = "custom: \(width)x\(height)"
        case .maximum:
            value = "maximum"
        case .notSet:
            value = "notSet"
        }
        return "[PhotoSettings \(value)]"
    }
}

extension PhotoResolution {
    
    func targetting(camera: Camera) -> IntSize {
        switch self {
        case .notSet, .maximum:
            return camera.maximumResolution
        case let .custom(width, height):
            let highest = camera.maximumResolution
            if width > highest.width || height > highest.height {
                let aspectRatio: Double = Double(height) / Double(width)
                let bestHeight = Int(Double(highest.width) * aspectRatio)
                return IntSize(width: highest.width, height: bestHeight)
            }
            return IntSize(width: width, height: height)
        }
    }
    
}
