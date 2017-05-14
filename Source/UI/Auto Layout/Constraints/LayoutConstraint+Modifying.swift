//
//  LayoutConstraint+Modifying.swift
//  Flexapp
//
//  Created by John Coates on 7/2/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    @discardableResult
    func setMultiplier(_ newMultiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(item: firstItem,
                                         attribute: firstAttribute,
                                         relatedBy: relation,
                                         toItem: secondItem,
                                         attribute: secondAttribute,
                                         multiplier: newMultiplier,
                                         constant: constant)
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier
        
        // deactivate this constraint
        NSLayoutConstraint.deactivate([self])
        
        // add & activate new constraint
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
