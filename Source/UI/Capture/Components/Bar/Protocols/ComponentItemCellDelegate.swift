//
//  ComponentItemCellDelegate.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

protocol ComponentItemCellDelegate: class {
    func add(component: Component.Type, atFrame frame: CGRect, fromView view: UIView)
}
