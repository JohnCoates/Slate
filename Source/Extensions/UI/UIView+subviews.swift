//
//  UIView+subviews.swift
//  Slate
//
//  Created by John Coates on 5/18/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

extension UIView {
    
    func add(subviews: [UIView]) {
        for subview in subviews {
            addSubview(subview)
        }
    }
    
}
