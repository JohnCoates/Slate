//
//  Int+Pixels.swift
//  Slate
//
//  Created by John Coates on 5/18/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

internal extension Int {
    var pixelsAsPoints: CGFloat {
        let scale = UIScreen.main.nativeScale
        let onePixel = 1.0 / scale
        return onePixel * CGFloat(self)
    }
}
