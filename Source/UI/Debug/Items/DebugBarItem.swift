//
//  DebugBarItem.swift
//  Slate
//
//  Created by John Coates on 12/28/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit

class DebugBarItem {
    
    var title: String
    var image: UIImage?
    var tapClosure: (() -> Void)?
    
    init(title: String, image: UIImage? = nil) {
        self.title = title
        self.image = image
    }
}
