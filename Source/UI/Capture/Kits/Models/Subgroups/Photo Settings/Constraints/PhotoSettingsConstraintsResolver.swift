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
    
    var resolutionConstraints: [ResolutionConstraint]? {
        if case .notSet = resolution {
            return nil
        }
        
        var constraints = [ResolutionConstraint]()
        for camera in CurrentDevice.cameras {
            if let cameraConstraints = self.constraints(forResolution: resolution,
                                                        camera: camera) {
                constraints.append(contentsOf: cameraConstraints)
            }
        }
        guard constraints.count > 0 else {
            return nil
        }
        return constraints
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
    
    private func constrainedByFrameRate(resolution: IntSize, camera: Camera) -> ResolutionConstraint? {
        let targetFrameRate = frameRate.targetting(camera: camera)
        guard let bestResolution = camera.highestResolution(forTargetFrameRate: targetFrameRate) else {
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
}

struct PhotoSettingsConstraint<ValueType> {
    var camera: Camera
    var constrained: PhotoSettingsPriority
    var by: PhotoSettingsPriority
    var originalValue: ValueType
    var constrainedValue: ValueType
}

extension Array where Element == PhotoSettingsConstraint<IntSize> {
    var constrainers: String {
        return self.map { $0.by.description }.unique.joined(separator: ", ")
    }
}
