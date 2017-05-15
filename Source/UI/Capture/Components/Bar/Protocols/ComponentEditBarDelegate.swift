//
//  ComponentEditBarDelegate.swift
//  Slate
//
//  Created by John Coates on 5/12/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

protocol ComponentEditBarDelegate: class {
    typealias UserConfirmedDeleteBlock = (_ deleted: Bool) -> Void
    
    func cancel(editingComponent: Component)
    func save(component: Component)
    func askUserForDeleteConfirmation(component: Component,
                                      userConfirmedBlock: @escaping UserConfirmedDeleteBlock)
}
