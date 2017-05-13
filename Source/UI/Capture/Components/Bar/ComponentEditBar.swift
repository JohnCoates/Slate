//
//  ComponentEditBar.swift
//  Slate
//
//  Created by John Coates on 5/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Cartography

final class ComponentEditBar: UIView {
    
    // MARK: - Init
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func initialSetup() {
        backgroundColor = UIColor(red:0.11, green:0.09,
                                  blue:0.11, alpha:0.44)
    }
    
    enum ProgressType {
        case size(range: Range<Float>)
        case rounding
    }
    
    var lastEditControl: UIView?
    var controls = [UIView]()
    
    func progressVariables(forType type: ProgressType) -> (
        minimumValue: Float, maximiumValue: Float, units: String?, name: String) {
            let minimumValue: Float
            let maximumValue: Float
            var units: String?
            let name: String
            
            switch type {
            case .size(let range):
                name = "Size"
                minimumValue = range.lowerBound
                maximumValue = range.upperBound
                units = "pt"
            case .rounding:
                name = "Rounding"
                minimumValue = 0
                maximumValue = 100
                units = "%"
            }
            return (minimumValue: minimumValue, maximiumValue: maximumValue, units: units, name: name)
    }
    
    func addProgressControl(type: ProgressType) {
        let variables = progressVariables(forType: type)
        let minimumValue = variables.minimumValue
        let maximumValue = variables.maximiumValue
        let units = variables.units
        let name = variables.name

        let control = CircleSlider()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.minimumValue = minimumValue
        control.maximumValue = maximumValue
        control.units = units
        control.value = currentProgressValue(forType: type)
        control.valueChangedHandler = valueHandler(forType: type)

        addSubview(control)
        controls.append(control)
        
        constrain(control) {
            let superview = $0.superview!
            $0.width == 50
            $0.height == $0.width
            
            $0.left >= superview.leftMargin
            $0.centerY == superview.centerY
        }
        
        if let lastEditControl = lastEditControl {
            constrain(control, lastEditControl) { control, lastEditControl in
                control.left == lastEditControl.right + 20
            }
        }
        
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        label.textColor = UIColor.white
        label.text = name
        addSubview(label)
        controls.append(label)
        
        constrain(control, label) { control, label in
            label.centerX == control.centerX
            label.top == control.bottom + 2
        }
        
        lastEditControl = control
    }
    
    func currentProgressValue(forType type: ProgressType) -> Float {
        switch type {
        case .rounding:
            return roundingValue()
        case .size(_):
            return sizeValue()
        }
    }
    
    func valueHandler(forType type: ProgressType) -> CircleSlider.ValueChangedCallback {
        switch type {
        case .rounding:
            return roundingValueHandler()
        case .size(_):
            return sizeValueHandler()
        }
    }
    
    func roundingValueHandler() -> CircleSlider.ValueChangedCallback {
        return { value in
            if let component = self.component as? EditRounding {
                component.rounding = value / 100
            }
        }
    }
    
    func sizeValueHandler() -> CircleSlider.ValueChangedCallback {
        return { value in
            guard let component = self.component as? EditSize else {
                fatalError("Component doesn't conform to EditSize")
            }
            component.size = value
        }
    }
    
    func roundingValue() -> Float {
        if let circleView = self.targetView as? CircleView {
            return circleView.roundingPercentage * 100
        }
        return 0
    }
    
    func sizeValue() -> Float {
        guard let component = self.component as? EditSize else {
            fatalError("Component doesn't conform to EditSize")
        }
        
        return component.size
    }
    
    var targetView: UIView?
    var component: Component?
    func set(target: Component) {
        for control in controls {
            control.removeFromSuperview()
        }
        
        if let oldTarget = targetView {
            oldTarget.layer.borderColor = nil
            oldTarget.layer.borderWidth = 0
        }
        
        component = target
        targetView = target.view
        targetView?.layer.borderColor = UIColor(red:0.13, green:0.55, blue:0.78, alpha:1.00).cgColor
        targetView?.layer.borderWidth = 3
        lastEditControl = nil
        
        if component is EditSize {
            addProgressControl(type: .size(range: 12..<200))
        }
        if component is EditRounding {
            addProgressControl(type: .rounding)
        }
    }
}
