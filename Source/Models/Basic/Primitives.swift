//
//  Primitives
//  Created on 4/7/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

struct IntSize {
    let width: Int
    let height: Int
}

import AVFoundation

extension IntSize {
    init(_ dimensions: CMVideoDimensions) {
        let width = Int(dimensions.width)
        let height = Int(dimensions.height)
        self.init(width: width, height: height)
    }
}
