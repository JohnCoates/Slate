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
    
    // MARK: - Hierarchy
    
    func ensureInHierarchy(views: [UIView]) {
        views.forEach(ensureInHierarchy(view:))
    }
    
    func ensureInHierarchy(view: UIView) {
        guard view.superview == nil else {
            return
        }
        
        addSubview(view)
    }
    
    func removeFromHiearchyAsNeeded(views: [UIView]) {
        views.forEach(removeFromHiearchyAsNeeded(view:))
    }
    
    func removeFromHiearchyAsNeeded(view: UIView) {
        guard view.superview != nil else {
            return
        }
        
        view.removeFromSuperview()
    }
    
}
