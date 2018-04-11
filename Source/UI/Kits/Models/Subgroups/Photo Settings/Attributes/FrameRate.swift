//
//  FrameRate
//  Created on 4/9/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

enum FrameRate: CustomStringConvertible {
    case custom(rate: Int)
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
    
    init(kind: Int, rate: Int?) {
        switch kind {
        case 0:
            guard let rate = rate else {
                fatalError("Custom rate missing value.")
            }
            self = .custom(rate: rate)
        case 1:
            self = .maximum
        case 2:
            self = .notSet
        default:
            fatalError("Unsupported kind for Frame Rate: \(kind))")
        }
    }
    
    var description: String {
        return userFacingDescription
    }
    
    var userFacingDescription: String {
        switch self {
        case let .custom(rate):
            return "\(rate)/sec"
        case .maximum:
            return "Maximum"
        case .notSet:
            return "Default"
        }
    }
}

extension FrameRate: CustomDebugStringConvertible {
    var debugDescription: String {
        var value: String
        switch self {
        case let .custom(rate):
            value = "custom: \(rate)"
        case .maximum:
            value = "maximum"
        case .notSet:
            value = "notSet"
        }
        return "[FrameRate \(value)]"
    }
}

extension FrameRate: PhotoSettingsConstrainable {
    typealias ValueType = Int
    var setting: PhotoSettingsPriority {
        return .frameRate
    }
    
    func optimalValue(for camera: Camera) -> Int {
        switch self {
        case .notSet:
            return min(camera.maximumFrameRate, 60)
        case .maximum:
            return camera.maximumFrameRate
        case let .custom(rate):
            return min(camera.maximumFrameRate, rate)
        }
    }
    
    func constrained<LeaderType: PhotoSettingsConstrainable>(value: ValueType,
                                                             leader: LeaderType,
                                                             camera: Camera) -> ValueType? {
        
        if let constraint: ValueConstraint<ValueType> = constrained(value: value, leader: leader, camera: camera) {
            return constraint.value
        } else {
            return nil
        }
    }
    
    func constrained<LeaderType: PhotoSettingsConstrainable>(value: ValueType,
                                                             leader: LeaderType,
                                                             camera: Camera) -> ValueConstraint<ValueType>? {
        
        switch leader.setting {
        case .resolution:
            let optimalValue: IntSize = Critical.cast(leader.optimalValue(for: camera))
            
            if let highestValue = camera.highestFrameRate(forResolution: optimalValue),
                highestValue < value {
                return ValueConstraint(highestValue, evaluateNewValue: { $1 < $0 })
            }
        case .burstSpeed:
            let optimalValue: Int = Critical.cast(leader.optimalValue(for: camera))
            if optimalValue > value {
                let constrainedValue = min(camera.maximumFrameRate, optimalValue)
                return ValueConstraint(constrainedValue, evaluateNewValue: { $1 > $0 })
            }
        case .frameRate:
            break
        }
        
        return nil
    }
    
}
