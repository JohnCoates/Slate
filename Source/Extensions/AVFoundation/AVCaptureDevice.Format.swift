//
//  AVCaptureDevice.Format
//  Created on 4/12/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import AVFoundation

extension AVCaptureDevice.Format {
    var dimensions: IntSize {
        let description = formatDescription
        let dimensions = CMVideoFormatDescriptionGetDimensions(description)
        return dimensions.intSize
    }
}

