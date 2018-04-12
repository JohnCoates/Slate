//
//  PhotoSettingsConstraintsResolver
//  Created on 4/10/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

class PhotoSettingsConstraintsResolver {
    
    private weak var _settings: PhotoSettings?
    private var settings: PhotoSettings {
        return Critical.unwrap(_settings)
    }
    
    private var resolution: PhotoResolution {
        return settings.resolution
    }
    
    private var frameRate: FrameRate {
        return settings.frameRate
    }
    
    private var burstSpeed: BurstSpeed {
        return settings.burstSpeed
    }
    
    init(settings: PhotoSettings) {
        _settings = settings
    }
    
    var resolutionConstraints: [PhotoResolution.Constraint]? {
        return constraints(for: resolution)
    }
    
    var frameRateConstraints: [FrameRate.Constraint]? {
        return constraints(for: frameRate)
    }
    
    var burstSpeedConstraints: [BurstSpeed.Constraint]? {
        return constraints(for: burstSpeed)
    }
    
    func constraints<Follower: PhotoSettingsConstrainable>(for follower: Follower) -> [Follower.Constraint]? {
        
        var constraints = [Follower.Constraint]()
        for camera in CurrentDevice.cameras {
            if let cameraConstraints = self.constraints2(for: follower, camera: camera) {
                constraints.append(contentsOf: cameraConstraints)
            }
        }
        
        return discard(value: constraints, ifZero: constraints.count)
    }
    
    func value<Follower: PhotoSettingsConstrainable>(for follower: Follower, camera: Camera,
                                                     afterConstraints constraintsMaybe: [Follower.Constraint]?)
        -> Follower.ValueType {
            var value = follower.optimalValue(for: camera)
            guard let constraints = constraintsMaybe else {
                return value
            }
            
            for constraint in constraints {
                guard constraint.camera === camera else {
                    continue
                }
                value = constraint.constrainedValue.value
            }
            
            return value
    }
    
    private func constraints2<Follower: PhotoSettingsConstrainable>(for follower: Follower,
                                                                    camera: Camera) -> [Follower.Constraint]? {
        typealias FollowerValue = Follower.ValueType
        typealias Constraint = Follower.Constraint
        let optimalValue = follower.optimalValue(for: camera)
        var constraints = [Constraint]()
        
        var currentBestValue = ValueConstraint(optimalValue)
        
        for priority in settings.priorities.items {
            guard settings.priorities.is(priority: priority, higherThan: follower.setting) else {
                continue
            }
            
            let constraintMaybe: Constraint?
            switch priority {
            case .frameRate:
                constraintMaybe = constraint(value: currentBestValue, camera: camera,
                                             follower: follower, leader: frameRate)
            case .resolution:
                constraintMaybe = constraint(value: currentBestValue, camera: camera,
                                             follower: follower, leader: resolution)
            case .burstSpeed:
                constraintMaybe = constraint(value: currentBestValue, camera: camera,
                                             follower: follower, leader: burstSpeed)
            }
            
            guard let constraint = constraintMaybe else {
                continue
            }
            
            if currentBestValue.value == constraint.constrainedValue.value {
                continue
            }
            currentBestValue = constraint.constrainedValue
            constraints.append(constraint)
        }
        
        guard constraints.count > 0 else {
            return nil
        }
        
        return constraints
    }
    
    private func constraint<Follower: PhotoSettingsConstrainable,
        Leader: PhotoSettingsConstrainable>(value: Follower.ConstrainedValue,
                                            camera: Camera,
                                            follower: Follower,
                                            leader: Leader) -> Follower.Constraint? {
        guard let constrainedValue: Follower.ConstrainedValue = follower.constrained(value: value.value, leader: leader,
                                                                                     camera: camera) else {
            return nil
        }
        
        if value.satisfiesConstraint(constrainedValue.value) {
            return PhotoSettingsConstraint(camera: camera,
                                           constrained: follower.setting,
                                           by: leader.setting,
                                           originalValue: value.value,
                                           constrainedValue: constrainedValue)
        }
        
        return nil
    }
}
