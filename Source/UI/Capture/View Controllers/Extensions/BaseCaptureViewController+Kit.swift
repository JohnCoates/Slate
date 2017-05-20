//
//  BaseCaptureViewController+Kit.swift
//  Slate
//
//  Created by John Coates on 5/19/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography

fileprivate typealias LocalClass = BaseCaptureViewController
extension BaseCaptureViewController {
    
    // MARK: - Rotation
    
    func transitionKit(to size: CGSize, orientation: UIInterfaceOrientation) {
        let orientation = UIApplication.shared.statusBarOrientation
        for component in kit.components {
            applyUprightTransform(forOrientation: orientation,
                                  toView: component.view)
            
        }
    }
    
}
