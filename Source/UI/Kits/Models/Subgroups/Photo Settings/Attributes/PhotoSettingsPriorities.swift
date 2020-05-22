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
    var items: [PhotoSettingsPriority]
    
    init() {
        self.items = PhotoSettingsPriorities.defaultOrder
    }
    
    private static var defaultOrder: [PhotoSettingsPriority] {
        return [
            .resolution,
            .frameRate,
            .burstSpeed
        ]
    }
    
    init(priorities: [Int]) {
        self.items = priorities.map {
            guard let priority = PhotoSettingsPriority(rawValue: $0) else {
                fatalError("Couldn't create priority from: \($0)")
            }
            return priority
        }
    }
    
    func `is`(priority: PhotoSettingsPriority,
              higherThan: PhotoSettingsPriority) -> Bool {
        guard let priorityIndex = items.firstIndex(of: priority),
            let higherThanIndex = items.firstIndex(of: higherThan) else {
            fatalError("Priority missing in comparsion between \(priority) and \(higherThan) in \(items)")
        }
        // the lower the index, the higher the priority
        return priorityIndex < higherThanIndex
    }
}

extension PhotoSettingsPriority: CustomStringConvertible {
    var description: String {
        switch self {
        case .resolution:
            return "Resolution"
        case .frameRate:
            return "Frame Rate"
        case .burstSpeed:
            return "Burst Speed"
        }
    }
}
