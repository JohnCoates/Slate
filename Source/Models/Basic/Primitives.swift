//
//  Primitives
//  Created on 4/7/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

struct IntSize: CustomStringConvertible {
    var width: Int
    var height: Int
    
    var description: String {
        return "\(width) x \(height)"
    }
}

extension IntSize: Equatable {}

func == (lhs: IntSize, rhs: IntSize) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
}

extension IntSize: Comparable {}

func < (lhs: IntSize, rhs: IntSize) -> Bool {
    return lhs.width < rhs.width || lhs.height < rhs.height
}

import AVFoundation

extension IntSize {
    init(_ dimensions: CMVideoDimensions) {
        let width = Int(dimensions.width)
        let height = Int(dimensions.height)
        self.init(width: width, height: height)
    }
}

extension CMVideoDimensions {
    var intSize: IntSize {
        return IntSize(width: Int(width), height: Int(height))
    }
}
