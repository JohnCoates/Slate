//
//  BarButton
//  Created on 4/9/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

struct BarButton {
    var title: String
    var style: UIBarButtonItemStyle
    weak var target: AnyObject?
    var action: Selector?
    
    init(title: String, style: UIBarButtonItemStyle = .plain,
         target: AnyObject?, action: Selector?) {
        self.title = title
        self.style = style
        self.target = target
        self.action = action
    }
}
