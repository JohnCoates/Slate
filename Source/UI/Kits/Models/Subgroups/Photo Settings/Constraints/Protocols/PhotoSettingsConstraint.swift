//
//  PhotoSettingsConstraint
//  Created on 4/11/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

struct PhotoSettingsConstraint<ValueType: Comparable>: BaseConstraint {
    var camera: Camera
    var constrained: PhotoSettingsPriority
    var by: PhotoSettingsPriority
    var originalValue: ValueType
    var constrainedValue: ValueConstraint<ValueType>
}
