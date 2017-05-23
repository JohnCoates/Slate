//
//  ComponentEditBarDelegate.swift
//  Slate
//
//  Created by John Coates on 5/12/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

protocol ComponentEditBarDelegate: class {
    
    // MARK: - Saving / Canceling Changes
    
    func save(component: Component)
    func cancel(editingComponent: Component)
    
    // MARK: - Deleting
    
    typealias UserConfirmedDeleteBlock = (_ deleted: Bool) -> Void
    
    func askUserForDeleteConfirmation(component: Component,
                                      userConfirmedBlock: @escaping UserConfirmedDeleteBlock)
    
    // MARK: - Changing Edit Mode
    
    func showEditModeAlert(controller: UIAlertController)
}
