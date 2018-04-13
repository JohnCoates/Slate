//
//  LayoutAnchorGenerator
//  Created on 4/13/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

struct LayoutAnchorGenerator {
    let target: AnchorTarget
    
    init(view: View) {
        self.target = .view(view)
    }
    
    init(target: AnchorTarget) {
        self.target = target
    }
    
    subscript(attribute: LayoutAttribute...) -> LayoutAnchors {
        return LayoutAnchors(target: target, attributes: attribute)
    }
}
