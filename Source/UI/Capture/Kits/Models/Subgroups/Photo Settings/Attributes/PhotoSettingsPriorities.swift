//
//  PhotoSettingsPriorities
//  Created on 4/9/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

enum PhotoSettingsPriority: Int {
    case resolution = 0
    case frameRate = 1
    case burstSpeed = 2
}

struct PhotoSettingsPriorities {
    var priorities: [PhotoSettingsPriority]
    
    init() {
        self.priorities = [
            .resolution,
            .frameRate,
            .burstSpeed
        ]
    }
    
    init(priorities: [Int]) {
        self.priorities = priorities.map {
            guard let priority = PhotoSettingsPriority(rawValue: $0) else {
                fatalError("Couldn't create priority from: \($0)")
            }
            return priority
        }
    }
}
