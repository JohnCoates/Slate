//
//  UILayoutSupport+Anchors
//  Created on 4/13/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

extension UILayoutSupport {
    var top: Anchor<YAxis> {
        return Anchor<YAxis>(target: .layoutSupport(self), kind: .top)
    }
    
    var bottom: Anchor<YAxis> {
        return Anchor<YAxis>(target: .layoutSupport(self), kind: .bottom)
    }
    
    var height: Anchor<Dimension> {
        return Anchor<Dimension>(target: .layoutSupport(self), kind: .height)
    }
}
