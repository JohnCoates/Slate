//
//  PhotoSettings.swift
//  Slate
//
//  Created by John Coates on 8/23/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreGraphics

class PhotoSettings {
    enum Resolution {
        case custom(width: CGFloat, height: CGFloat)
        case maximum
        case notSet
    }
    
    enum FrameRate {
        case custom(rate: Float)
        case maximum
        case notSet
    }
    
    enum BurstSpeed {
        case custom(speed: Int)
        case maximum
        case notSet
    }
    
    var resolution: Resolution = .notSet
    var frameRate: FrameRate = .notSet
    var burstSpeed: BurstSpeed = .notSet
    
}
