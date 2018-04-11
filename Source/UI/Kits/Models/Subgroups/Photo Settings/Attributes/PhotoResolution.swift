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
            let size = Critical.unwrap(size)
            self = .custom(width: Int(size.width), height: Int(size.height))
        case 1:
            self = .maximum
        case 2:
            self = .notSet
        default:
            Critical.unsupported(value: kind)
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
        return "[\(type(of: self)) \(value)]"
    }
}

extension PhotoResolution: PhotoSettingsConstrainable {
    typealias ValueType = IntSize
    var setting: PhotoSettingsPriority {
        return .resolution
    }
    
    func optimalValue(for camera: Camera) -> IntSize {
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
    
    func constrained<LeaderType: PhotoSettingsConstrainable>(value: ValueType,
                                                             leader: LeaderType,
                                                             camera: Camera) -> ValueType? {
        
        switch leader.setting {
        case .frameRate, .burstSpeed:
            let optimalValue: Int = Critical.cast(leader.optimalValue(for: camera))
            
            if let constrainedValue = camera.highestResolution(forFrameRate: optimalValue),
                constrainedValue < value {
                return constrainedValue
            } else {
                return nil
            }
        case .resolution:
            return nil
        }
    }
    
}
