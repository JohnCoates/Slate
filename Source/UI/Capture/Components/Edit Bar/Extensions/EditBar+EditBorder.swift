//
//  EditBar+EditBorder.swift
//  Slate
//
//  Created by John Coates on 6/3/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import UIKit

extension ComponentEditBar {
    
    func addEditBorder(forView view: UIView) {
        let target = borderView(forView: view)
        target.layer.borderColor = UIColor(red: 0.13, green: 0.55,
                                           blue: 0.78, alpha: 1.00).cgColor
        target.layer.borderWidth = 3
    }
    
    func resetEditBorder(forView view: UIView) {
        let target = borderView(forView: view)
        target.layer.borderColor = nil
        target.layer.borderWidth = 0
    }
    
    func borderView(forView view: UIView) -> UIView {
        let target: UIView
        if let button = view as? Button {
            target = button.contentView
        } else {
            target = view
        }
        return target
    }

}
