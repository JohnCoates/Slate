//
//  UILayoutGuide+Anchors
//  Created on 4/13/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

extension UILayoutGuide: Anchorable {
    var anchorTarget: AnchorTarget {
        return .layoutGuide(self)
    }
}
