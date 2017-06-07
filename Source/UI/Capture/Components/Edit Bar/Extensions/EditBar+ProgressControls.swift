//
//  ComponentEditBar+ProgressControls.swift
//  Slate
//
//  Created by John Coates on 6/3/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

fileprivate typealias LocalClass = ComponentEditBar
extension ComponentEditBar {

    struct ProgressSettings {
        let name: String
        let minimumValue: Float
        let maximumValue: Float
        let units: String?
    }
    
    static let progressControlWidth: CGFloat = 50
    func addProgressControl(settings: ComponentEditBar.ProgressSettings,
                            initialValue: Float,
                            valueHandler: @escaping CircleSlider.ValueChangedCallback) {
        let control = CircleSlider()
        control.minimumValue = settings.minimumValue
        control.maximumValue = settings.maximumValue
        control.units = settings.units
        control.value = initialValue
        control.valueChangedHandler = valueHandler
        
        addSubview(control)
        controls.append(control)
        
        control.width --> LocalClass.progressControlWidth
        control.height --> control.width
        control.left -->+= leftMargin
        control.centerY --> centerY
        
        setLeftConstraint(forControl: control)
        addTitleLabel(withText: settings.name, forControl: control)
        
    }
    
    // MARK: - Overloads
    
    func addProgressControl(forEditProtocol target: EditSize) {
        let settings = ProgressSettings(name: "Size",
                                        minimumValue: target.minimumSize,
                                        maximumValue: target.maximumSize,
                                        units: "pt")
        addProgressControl(settings: settings,
                           initialValue: target.size,
                           valueHandler: { target.size = $0 })
    }
    
    func addProgressControl(forEditProtocol target: EditRounding) {
        let settings = ProgressSettings(name: "Rounding",
                                        minimumValue: 0,
                                        maximumValue: 100,
                                        units: "%")
        addProgressControl(settings: settings,
                           initialValue: target.rounding * 100,
                           valueHandler: { target.rounding = $0 / 100 })
    }
    
    func addProgressControl(forEditProtocol target: EditOpacity) {
        let settings = ProgressSettings(name: "Opacity",
                                        minimumValue: target.minimumOpacity * 100,
                                        maximumValue: target.maximumOpacity * 100,
                                        units: "%")
        addProgressControl(settings: settings,
                           initialValue: target.opacity * 100,
                           valueHandler: { target.opacity = $0 / 100 })
    }
}
