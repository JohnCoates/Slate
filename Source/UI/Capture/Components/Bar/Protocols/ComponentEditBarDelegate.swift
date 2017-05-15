//
//  ComponentEditBarDelegate.swift
//  Slate
//
//  Created by John Coates on 5/12/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

protocol ComponentEditBarDelegate: class {
    func cancel(editingComponent: Component)
    func save(component: Component)
    func delete(component: Component)
}
