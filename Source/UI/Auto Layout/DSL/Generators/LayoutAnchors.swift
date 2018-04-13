//
//  LayoutAnchors
//  Created on 4/13/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

struct LayoutAnchors {
    let target: AnchorTarget
    let attributes: [LayoutAttribute]

    init(target: AnchorTarget, attributes: [LayoutAttribute]) {
        self.target = target
        self.attributes = attributes
    }
}
