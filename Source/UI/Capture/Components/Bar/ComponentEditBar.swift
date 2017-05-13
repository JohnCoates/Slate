//
//  ComponentEditBar.swift
//  Slate
//
//  Created by John Coates on 5/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Cartography

fileprivate typealias localClass = ComponentEditBar

final class ComponentEditBar: UIView {
    
    var delegate: ComponentEditBarDelegate?
    
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
        
        setUpSaveButton()
        setUpCancelButton()
    }
    
    let saveButton = UIButton(type: .custom)
    fileprivate func setUpSaveButton() {
        saveButton.backgroundColor = UIColor(red:0.27, green:0.77, blue:0.08, alpha:1.00)
        saveButton.layer.cornerRadius = 6
        saveButton.addTarget(self, action: .saveTapped, for: .touchUpInside)
        addSubview(saveButton)
        
        constrain(saveButton) {
            let superview = $0.superview!
            $0.width == 35
            $0.height == 35
            $0.top == superview.top + 15
            $0.right == superview.right - 10
        }
    }
    
    let cancelButton = UIButton(type: .custom)
    fileprivate func setUpCancelButton() {
        cancelButton.backgroundColor = UIColor(red:0.86, green:0.25, blue:0.25, alpha:1.00)
        cancelButton.layer.cornerRadius = saveButton.layer.cornerRadius
        cancelButton.addTarget(self, action: .cancelTapped, for: .touchUpInside)
        addSubview(cancelButton)
        
        constrain(cancelButton, saveButton) { cancelButton, saveButton in
            cancelButton.size == saveButton.size
            cancelButton.top == saveButton.bottom + 2
            cancelButton.left == saveButton.left
        }
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
    
    // MARK: - Values
    
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
        targetView?.layer.borderColor = UIColor(red:0.13, green:0.55,
                                                blue:0.78, alpha:1.00).cgColor
        targetView?.layer.borderWidth = 3
        lastEditControl = nil
        
        if let editSize = component as? EditSize {
            let sizeRange = editSize.minimumSize..<editSize.maximumSize
            addProgressControl(type: .size(range: sizeRange))
        }
        if component is EditRounding {
            addProgressControl(type: .rounding)
        }
    }
    
    // MARK: - Save, Cancel
    
    func saveTapped() {
        stopEditing()
        guard let component = component else {
            fatalError("Not editing a component!")
        }
        delegate?.save(component: component)
    }
    
    func cancelTapped() {
        stopEditing()
        guard let component = component else {
            fatalError("Not editing a component!")
        }
        delegate?.cancel(editingComponent: component)
    }
    
    func stopEditing() {
        isHidden = true
        if let targetView = targetView {
            targetView.layer.borderColor = nil
            targetView.layer.borderWidth = 0
            self.targetView = nil
        }   
    }
}

// MARK: - Selector Extension

fileprivate extension Selector {
    static let saveTapped = #selector(localClass.saveTapped)
    static let cancelTapped = #selector(localClass.cancelTapped)
}
