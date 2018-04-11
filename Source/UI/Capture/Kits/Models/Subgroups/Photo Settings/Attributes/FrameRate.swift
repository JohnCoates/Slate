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

extension FrameRate {
    
    func targetting(camera: Camera) -> Int {
        return optimalValue(for: camera)
    }
    
    func optimalValue(for camera: Camera) -> Int {
        switch self {
        case .notSet, .maximum:
            return camera.maximumFrameRate
        case let .custom(rate):
            return min(camera.maximumFrameRate, rate)
        }
    }
    
}

extension FrameRate: PhotoSettingsConstrainable, GenericPhotoSettingsConstrainable {
    typealias ValueType = Int
    var setting: PhotoSettingsPriority {
        return .frameRate
    }
    
    func constrained<LeaderType: GenericPhotoSettingsConstrainable>(value: ValueType,
                                                                    leader: LeaderType,
                                                                    camera: Camera) -> ValueType? {
        
        switch leader.setting {
        case .resolution:
            let optimalValue: IntSize = Critical.cast(leader.optimalValue(for: camera))
            return camera.highestFrameRate(forResolution: optimalValue)
        case .burstSpeed, .frameRate:
            return nil
        }
    }
}
