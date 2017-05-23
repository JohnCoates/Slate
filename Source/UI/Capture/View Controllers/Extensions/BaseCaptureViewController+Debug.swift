//
//  BaseCaptureViewController+Debug.swift
//  Slate
//
//  Created by John Coates on 5/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import UIKit

extension BaseCaptureViewController: DebugBarDelegate {
    var debugBarItems: [DebugBarItem] {
        let clearComponents = DebugBarItem(title: "Clear Components")
        clearComponents.tapClosure = { [unowned self] in
            self.removeAllComponents()
        }
        
        let switchCamera = DebugBarItem(title: "Switch Camera")
        switchCamera.tapClosure = { [unowned self] in
            self.switchCamera()
        }
        
        return [clearComponents, switchCamera]
    }
    
    func removeAllComponents() {
        for component in kit.components {
            component.view.removeFromSuperview()
        }
        
        kit.components.removeAll()
        kit.saveKit()
    }
}
