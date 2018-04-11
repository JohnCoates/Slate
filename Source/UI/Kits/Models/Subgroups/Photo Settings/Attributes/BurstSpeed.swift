//
//  BurstSpeed
//  Created on 4/11/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

enum BurstSpeed {
    case custom(speed: Int)
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
    
    init(kind: Int, speed: Int?) {
        switch kind {
        case 0:
            self = .custom(speed: Critical.unwrap(speed))
        case 1:
            self = .maximum
        case 2:
            self = .notSet
        default:
            Critical.unsupported(value: kind)
        }
    }
}

extension BurstSpeed: CustomDebugStringConvertible {
    var debugDescription: String {
        var value: String
        switch self {
        case let .custom(speed):
            value = "custom: \(speed)"
        case .maximum:
            value = "maximum"
        case .notSet:
            value = "notSet"
        }
        return "[\(type(of: self)) \(value)]"
    }
}

extension BurstSpeed: CustomStringConvertible {
    var description: String {
        switch self {
        case let .custom(speed):
            return "\(speed)/sec"
        case .maximum:
            return "Maximum"
        case .notSet:
            return "Default"
        }
    }
}

extension BurstSpeed: PhotoSettingsConstrainable {
    typealias ValueType = Int
    var setting: PhotoSettingsPriority {
        return .burstSpeed
    }
    
    func optimalValue(for camera: Camera) -> Int {
        switch self {
        case .notSet:
            return 5
        case .maximum:
            return camera.maximumFrameRate
        case let .custom(rate):
            return min(camera.maximumFrameRate, rate)
        }
    }
    
    func constrained<LeaderType: PhotoSettingsConstrainable>(value: ValueType,
                                                             leader: LeaderType,
                                                             camera: Camera) -> ValueType? {
        
        switch leader.setting {
        case .resolution:
            let optimalValue: IntSize = Critical.cast(leader.optimalValue(for: camera))
            return camera.highestFrameRate(forResolution: optimalValue)
        case .frameRate:
            let optimalValue: Int = Critical.cast(leader.optimalValue(for: camera))
            let ownOptimalValue: Int = Critical.cast(self.optimalValue(for: camera))
            
            if optimalValue < ownOptimalValue {
                return optimalValue
            }
        case .burstSpeed:
            break
        }
        return nil
    }
}
