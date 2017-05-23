//
//  ComponentMenuBarDelegate.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

protocol ComponentMenuBarDelegate: class {
    func add(component: Component.Type, atFrame frame: CGRect, fromView view: UIView)
}
