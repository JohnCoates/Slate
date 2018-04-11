//
//  EditBar+SettingComponent.swift
//  Slate
//
//  Created by John Coates on 6/3/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

extension ComponentEditBar {
    
    func set(target: Component) {
        clearInitialState()
        
        for control in controls {
            control.removeFromSuperview()
        }
        
        if let oldTarget = targetView {
            resetEditBorder(forView: oldTarget)
        }
        
        titleLabel.text = target.editTitle
        component = target
        let view = target.view
        addEditBorder(forView: view)
        targetView = view
        
        lastEditControl = nil
        
        addEditControls(forComponent: target)
    }
    
    func addEditControls(forComponent component: Component) {
        if let target = component as? EditPosition {
            initialValues[.position] = target.origin
        }
        if let target = component as? EditSize {
            initialValues[.size] = target.size
            addProgressControl(forEditProtocol: target)
        }
        if let target = component as? EditRounding {
            initialValues[.rounding] = target.rounding
            addProgressControl(forEditProtocol: target)
        }
        if let target = component as? EditOpacity {
            initialValues[.opacity] = target.opacity
            addProgressControl(forEditProtocol: target)
        }
        
        addDeleteControl()
    }
    
}
