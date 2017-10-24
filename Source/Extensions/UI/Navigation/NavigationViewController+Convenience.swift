//
//  NavigationViewController+Convenience.swift
//  Slate
//
//  Created by John Coates on 10/23/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

protocol NavigationConvenience {
    func setUpMinimalistBackButton()
}

extension NavigationConvenience where Self: UIViewController {
    
    func setUpMinimalistBackButton() {
        let minimalistBackButton = UIBarButtonItem(title: " ",
                                                   style: .plain,
                                                   target: nil,
                                                   action: nil)
        navigationItem.backBarButtonItem = minimalistBackButton
    }
    
}
