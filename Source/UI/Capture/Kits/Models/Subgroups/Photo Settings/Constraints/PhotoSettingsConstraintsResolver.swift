//
//  PhotoSettingsConstraintsResolver
//  Created on 4/10/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

class PhotoSettingsConstraintsResolver {
    
    private weak var _settings: PhotoSettings?
    var settings: PhotoSettings {
        return Critical.unwrap(_settings)
    }
    
    var resolution: PhotoResolution {
        return settings.resolution
    }
    
    var frameRate: FrameRate {
        return settings.frameRate
    }
    
    init(settings: PhotoSettings) {
        _settings = settings
    }
    
    typealias ResolutionConstraint = PhotoSettingsConstraint<IntSize>
    typealias FrameRateConstraint = PhotoSettingsConstraint<Int>
    
    var resolutionConstraints: [ResolutionConstraint]? {
        return constraints(for: resolution)
    }
    
    var frameRateConstraints: [FrameRateConstraint]? {
        if case .notSet = frameRate {
            return nil
        }
        
        var constraints = [FrameRateConstraint]()
        for camera in CurrentDevice.cameras {
            if let cameraConstraints = self.constraints(forFrameRate: frameRate,
                                                        camera: camera) {
                constraints.append(contentsOf: cameraConstraints)
            }
        }
        
        guard constraints.count > 0 else {
            return nil
        }
        return constraints
    }
    
    func constraints<Follower: PhotoSettingsConstrainable>(for follower: Follower) -> [PhotoSettingsConstraint<Follower.ValueType>]?  {
        
        var constraints = [PhotoSettingsConstraint<Follower.ValueType>]()
        for camera in CurrentDevice.cameras {
            if let cameraConstraints = self.constraints(for: follower, camera: camera) {
                constraints.append(contentsOf: cameraConstraints)
            }
        }
        
        return discard(value: constraints, ifZero: constraints.count)
    }
    
    func resolution(forCamera camera: Camera,
                    afterConstraints constraintsMaybe: [ResolutionConstraint]?) -> IntSize {
        var resolution = self.resolution.targetting(camera: camera)
        guard let constraints = constraintsMaybe else {
            return resolution
        }
        
        for constraint in constraints {
            guard constraint.camera === camera else {
                continue
            }
            
            resolution = constraint.constrainedValue
        }
        
        return resolution
    }
    
    func frameRate(forCamera camera: Camera,
                   afterConstraints constraintsMaybe: [FrameRateConstraint]?) -> Int {
        var frameRate = self.frameRate.targetting(camera: camera)
        guard let constraints = constraintsMaybe else {
            return frameRate
        }
        
        for constraint in constraints {
            guard constraint.camera === camera else {
                continue
            }
            
            frameRate = constraint.constrainedValue
        }
        
        return frameRate
    }
    
    private func constraints(forResolution resolution: PhotoResolution,
                             camera: Camera) -> [ResolutionConstraint]? {
        let targetResolution = resolution.targetting(camera: camera)
        var constraints = [ResolutionConstraint]()
        
        var currentBestResolution = targetResolution
        for priority in settings.priorities.items {
            if case .resolution = priority {
                continue
            }
            
            guard settings.priorities.is(priority: priority, higherThan: .resolution) else {
                continue
            }
            
            let constraintMaybe: ResolutionConstraint?
            switch priority {
            case .frameRate:
                constraintMaybe = constrainedByFrameRate(resolution: currentBestResolution, camera: camera)
            case .resolution, .burstSpeed:
                continue
            }
            
            guard let constraint = constraintMaybe else {
                continue
            }
            currentBestResolution = constraint.constrainedValue
            constraints.append(constraint)
        }
        
        guard constraints.count > 0 else {
            return nil
        }
        
        return constraints
    }
    
    private func constraintsGeneric(forResolution resolution: PhotoResolution,
                                    camera: Camera) -> [ResolutionConstraint]? {
        let targetResolution = resolution.targetting(camera: camera)
        var constraints = [ResolutionConstraint]()
        
        var currentBestResolution = targetResolution
        for priority in settings.priorities.items {
            if case .resolution = priority {
                continue
            }
            
            guard settings.priorities.is(priority: priority, higherThan: .resolution) else {
                continue
            }
            
            let constraintMaybe: ResolutionConstraint?
            switch priority {
            case .frameRate:
                constraintMaybe = constraint(value: currentBestResolution, camera: camera,
                                             follower: resolution, leader: frameRate)
            case .resolution, .burstSpeed:
                continue
            }
            
            guard let constraint = constraintMaybe else {
                continue
            }
            currentBestResolution = constraint.constrainedValue
            constraints.append(constraint)
        }
        
        guard constraints.count > 0 else {
            return nil
        }
        
        return constraints
    }
    
    private func constraints<Follower: PhotoSettingsConstrainable>(for follower: Follower,
                                                                          camera: Camera) -> [PhotoSettingsConstraint<Follower.ValueType>]? {
        typealias FollowerValue = Follower.ValueType
        typealias ConstraintType = PhotoSettingsConstraint<FollowerValue>
        let optimalValue = follower.optimalValue(for: camera)
        var constraints = [ConstraintType]()
        
        var currentBestValue = optimalValue
        for priority in settings.priorities.items {
            guard settings.priorities.is(priority: priority, higherThan: follower.setting) else {
                continue
            }
            
            let constraintMaybe: ConstraintType?
            switch priority {
            case .frameRate:
                constraintMaybe = constraint(value: currentBestValue, camera: camera,
                                             follower: follower, leader: frameRate)
            case .resolution, .burstSpeed:
                continue
            }
            
            guard let constraint = constraintMaybe else {
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
    
    private func constraints(forFrameRate frameRate: FrameRate, camera: Camera) -> [FrameRateConstraint]? {
        let targetFrameRate = frameRate.targetting(camera: camera)
        var constraints = [FrameRateConstraint]()
        
        var currentBestFrameRate = targetFrameRate
        for priority in settings.priorities.items {
            if case .frameRate = priority {
                continue
            }
            
            guard settings.priorities.is(priority: priority, higherThan: .frameRate) else {
                continue
            }
            
            let constraintMaybe: FrameRateConstraint?
            switch priority {
            case .resolution:
                constraintMaybe = constraintedByResolution(frameRate: currentBestFrameRate, camera: camera)
            case .frameRate, .burstSpeed:
                continue
            }
            
            guard let constraint = constraintMaybe else {
                continue
            }
            
            currentBestFrameRate = constraint.constrainedValue
            constraints.append(constraint)
        }
        
        guard constraints.count > 0 else {
            return nil
        }
        
        return constraints
    }
    
    private func constraint<ValueType: Comparable>(forValue value: ValueType, camera: Camera,
                                                   optimalValueUnderOpposingValue: ((Camera) -> ValueType?))
        -> PhotoSettingsConstraint<ValueType>? {
        guard let bestValue = optimalValueUnderOpposingValue(camera) else {
            return nil
        }
        
        if bestValue < value {
            return PhotoSettingsConstraint(camera: camera,
                                           constrained: .resolution,
                                           by: .frameRate, originalValue: value, constrainedValue: bestValue)
        }
        
        return nil
    }
    
    private func constraint<FollowType: PhotoSettingsConstrainable,
        LeaderType: PhotoSettingsConstrainable>(value: FollowType.ValueType,
                                                       camera: Camera,
                                                       follower: FollowType,
                                                       leader: LeaderType)
        -> PhotoSettingsConstraint<FollowType.ValueType>? {
        guard let constrainedValue = follower.constrained(value: value, leader: leader, camera: camera) else {
            return nil
        }
        
        if constrainedValue < value {
            return PhotoSettingsConstraint(camera: camera,
                                           constrained: follower.setting,
                                           by: leader.setting,
                                           originalValue: value, constrainedValue: constrainedValue)
        }
        
        return nil
    }
    
    private func constrainedByFrameRate(resolution: IntSize, camera: Camera) -> ResolutionConstraint? {
        let targetFrameRate = frameRate.targetting(camera: camera)
        guard let bestResolution = camera.highestResolution(forFrameRate: targetFrameRate) else {
            return nil
        }
        
        if bestResolution.width < resolution.width || bestResolution.height < resolution.height {
            return ResolutionConstraint(camera: camera,
                                        constrained: .resolution,
                                        by: .frameRate,
                                        originalValue: resolution,
                                        constrainedValue: bestResolution)
        }
        
        return nil
    }
    
    private func constraintedByResolution(frameRate: Int,
                                          camera: Camera) -> FrameRateConstraint? {
        let targetResolution = resolution.targetting(camera: camera)
        guard let bestFrameRate = camera.highestFrameRate(forResolution: targetResolution) else {
            return nil
        }
        
        if bestFrameRate < frameRate {
            return FrameRateConstraint(camera: camera,
                                       constrained: .frameRate,
                                       by: .resolution,
                                       originalValue: frameRate,
                                       constrainedValue: bestFrameRate)
        }
        
        return nil
    }
}

protocol PhotoSettingsConstrainable {
    associatedtype ValueType: Comparable
    var setting: PhotoSettingsPriority { get }
    func optimalValue(for camera: Camera) -> ValueType
    
    func constrained<LeaderType: PhotoSettingsConstrainable>(value: ValueType,
                                                                    leader: LeaderType,
                                                                    camera: Camera) -> ValueType?
}

struct PhotoSettingsConstraint<ValueType>: Constraint {
    var camera: Camera
    var constrained: PhotoSettingsPriority
    var by: PhotoSettingsPriority
    var originalValue: ValueType
    var constrainedValue: ValueType
}

protocol Constraint {
    associatedtype Kind: CustomStringConvertible
    var by: Kind { get }
}

extension Array where Element: Constraint {
    var constrainers: String {
        return self.map { $0.by.description }.unique.joined(separator: ", ")
    }
}
