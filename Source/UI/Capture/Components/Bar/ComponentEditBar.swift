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
    
    let saveButton = InverseMaskButton(icon: CheckmarkIcon())
    fileprivate func setUpSaveButton() {
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
    
    let cancelButton = InverseMaskButton(icon: XIcon())
    fileprivate func setUpCancelButton() {
        cancelButton.addTarget(self, action: .cancelTapped, for: .touchUpInside)
        addSubview(cancelButton)
        
        constrain(cancelButton, saveButton) { cancelButton, saveButton in
            cancelButton.size == saveButton.size
            cancelButton.top == saveButton.bottom + 2
            cancelButton.left == saveButton.left
        }
    }
    
    // MARK: - Progress Controls
    
    struct ProgressSettings {
        let name: String
        let minimumValue: Float
        let maximumValue: Float
        let units: String?
    }
    var lastEditControl: UIView?
    var controls = [UIView]()
    
    func addProgressControl(settings: ProgressSettings,
                            initialValue: Float,
                            valueHandler: @escaping CircleSlider.ValueChangedCallback) {
        let control = CircleSlider()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.minimumValue = settings.minimumValue
        control.maximumValue = settings.maximumValue
        control.units = settings.units
        control.value = initialValue
        control.valueChangedHandler = valueHandler

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
        label.text = settings.name
        addSubview(label)
        controls.append(label)
        
        constrain(control, label) { control, label in
            label.centerX == control.centerX
            label.top == control.bottom + 2
        }
        
        lastEditControl = control
    }
    
    // MARK: - Progress Control Overloads
    
    func addProgressControl(forSize editSize: EditSize) {
        let settings = ProgressSettings(name: "Size",
                                        minimumValue: editSize.minimumSize,
                                        maximumValue: editSize.maximumSize,
                                        units: "pt")
        addProgressControl(settings: settings,
                           initialValue: editSize.size,
                           valueHandler: { editSize.size = $0 })
    }
    
    func addProgressControl(forRounding editRounding: EditRounding) {
        let settings = ProgressSettings(name: "Rounding",
                                        minimumValue: 0,
                                        maximumValue: 100,
                                        units: "%")
        addProgressControl(settings: settings,
                           initialValue: editRounding.rounding * 100,
                           valueHandler: { editRounding.rounding = $0 / 100 })
    }
    
    // MARK: - Setting Component
    
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
            addProgressControl(forSize: editSize)
        }
        if let editRounding = component as? EditRounding {
            addProgressControl(forRounding: editRounding)
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
