//
//  Orientation+Convenience
//  Created on 4/15/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

extension UIInterfaceOrientation: CustomStringConvertible {
    var device: UIDeviceOrientation {
        switch self {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .portrait:
            fallthrough
        default:
            return .portrait
        }
    }
    
    public var description: String {
        switch self {
        case .landscapeLeft:
            return "landscapeLeft"
        case .landscapeRight:
            return "landscapeRight"
        case .portraitUpsideDown:
            return "portraitUpsideDown"
        case .portrait:
            return "portrait"
        case .unknown:
            return "unknown"
        }
    }
}

extension UIDeviceOrientation {
    var interface: UIInterfaceOrientation {
        switch self {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .portrait:
            fallthrough
        default:
            return .portrait
        }
    }
}
