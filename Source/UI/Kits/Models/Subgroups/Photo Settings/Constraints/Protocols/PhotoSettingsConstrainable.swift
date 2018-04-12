//
//  PhotoSettingsConstrainable
//  Created on 4/11/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

protocol PhotoSettingsConstrainable {
    associatedtype ValueType: Comparable
    var setting: PhotoSettingsPriority { get }
    func optimalValue(for camera: Camera) -> ValueType
    
    func constrained<Leader: PhotoSettingsConstrainable>(value: ValueType,
                                                         leader: Leader,
                                                         camera: Camera) -> ValueType?
    
    func constrained<LeaderType: PhotoSettingsConstrainable>(value: ValueType,
                                                             leader: LeaderType,
                                                             camera: Camera) -> ConstrainedValue?
}

extension PhotoSettingsConstrainable {
    typealias Constraint = PhotoSettingsConstraint<ValueType>
    typealias ConstrainedValue = ValueConstraint<ValueType>
}
