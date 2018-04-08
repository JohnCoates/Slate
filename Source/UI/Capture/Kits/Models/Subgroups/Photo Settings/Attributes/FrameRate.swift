//
//  FrameRate
//  Created on 4/9/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

enum FrameRate {
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
