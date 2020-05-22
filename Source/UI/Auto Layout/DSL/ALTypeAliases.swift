//
//  ALTypeAliases
//  Created on 4/6/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
    typealias LayoutAttribute = NSLayoutConstraint.Attribute
    typealias LayoutRelation = NSLayoutConstraint.Relation
    typealias LayoutPriority = UILayoutPriority
#else
    import AppKit
    typealias LayoutAttribute = NSLayoutConstraint.Attribute
    typealias LayoutRelation = NSLayoutConstraint.Relation
    typealias LayoutPriority = NSLayoutConstraint.Priority
#endif
