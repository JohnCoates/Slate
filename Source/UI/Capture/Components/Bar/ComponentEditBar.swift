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
        addDeleteControl()
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
    
    static let progressControlWidth: CGFloat = 50
    func addProgressControl(settings: ProgressSettings,
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
        
        constrain(control) {
            let superview = $0.superview!
            $0.width == localClass.progressControlWidth
            $0.height == $0.width
            
            $0.left >= superview.leftMargin
            $0.centerY == superview.centerY
        }
        
        setLeftConstraint(forControl: control)
        addTitleLabel(withText: settings.name, forControl: control)
        
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
    
    // MARK: - Delete Control
    
    func addDeleteControl() {
        let control = CodeIconButton(icon: DeleteLineIcon())
        control.rounding = 1
        control.backgroundColor = UIColor(red:0.16, green:0.14, blue:0.17, alpha:1.00)
        control.setTappedCallback(instance: self, method: Method.deleteTapped)
        addSubview(control)
        controls.append(control)
        
        let innerCircleWidth = CircleSlider.defaultInnerWidth(withOuterWidth: localClass.progressControlWidth)
        constrain(control) {
            let superview = $0.superview!
            $0.width == innerCircleWidth
            $0.height == $0.width
            
            $0.left >= superview.leftMargin
            $0.centerY == superview.centerY
        }
        
        setLeftConstraint(forControl: control)
        addTitleLabel(withText: "Delete", forControl: control)
    }
    
    // MARK: - Control Utilities
    
    func setLeftConstraint(forControl control: UIView) {
        if let lastEditControl = lastEditControl {
            constrain(control, lastEditControl) { control, lastEditControl in
                control.left == lastEditControl.right + 20
            }
        }
        lastEditControl = control
    }
    
    func addTitleLabel(withText text: String, forControl control: UIView) {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        label.textColor = UIColor.white
        label.text = text
        addSubview(label)
        controls.append(label)
        
        constrain(control, label) { control, label in
            let superview = label.superview!
            label.centerX == control.centerX
            label.bottom == superview.bottom - 9
        }
    }
    
    // MARK: - Setting Component
    
    var targetView: UIView?
    var component: Component?
    func set(target: Component) {
        clearInitialState()
        
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
        
        addEditControls(forComponent: target)
    }
    
    func addEditControls(forComponent component: Component) {
        if let editSize = component as? EditSize {
            initialSize = editSize.size
            addProgressControl(forSize: editSize)
        }
        if let editRounding = component as? EditRounding {
            initialRounding = editRounding.rounding
            addProgressControl(forRounding: editRounding)
        }
        if let editPosition = component as? EditPosition {
            initialPosition = editPosition.origin
        }
        
        addDeleteControl()
    }
    
    // MARK: - Initial State
    
    var initialSize: Float?
    var initialRounding: Float?
    var initialPosition: CGPoint?
    
    func resetToInitialState(component: Component) {
        if let editSize = component as? EditSize {
            guard let initialSize = initialSize else {
                fatalError("Didn't record initial size for component: \(component)")
            }
            editSize.size = initialSize
        }
        if let editRounding = component as? EditRounding {
            guard let initialRounding = initialRounding else {
                fatalError("Didn't record initial rounding for component: \(component)")
            }
            editRounding.rounding = initialRounding
        }
        if let editPosition = component as? EditPosition {
            guard let initialPosition = initialPosition else {
                fatalError("Didn't record initial position for component: \(component)")
            }
            editPosition.origin = initialPosition
        }
    }
    
    func clearInitialState() {
        initialSize = nil
        initialRounding = nil
        initialPosition = nil
    }
    
    // MARK: - Save, Cancel
    
    func saveTapped() {
        let component = requiredComponent(forFunction: #function)
        let delegate = requiredDelegate(forFunction: #function)
        stopEditing()
        delegate.save(component: component)
    }
    
    func cancelTapped() {
        let component = requiredComponent(forFunction: #function)
        let delegate = requiredDelegate(forFunction: #function)
        resetToInitialState(component: component)
        stopEditing()
        delegate.cancel(editingComponent: component)
    }
    
    func deleteTapped() {
        let component = requiredComponent(forFunction: #function)
        let delegate = requiredDelegate(forFunction: #function)
        delegate.askUserForDeleteConfirmation(component: component) { didDelete in
            if didDelete {
                self.stopEditing()
            }
        }
    }
    
    private func stopEditing() {
        isHidden = true
        if let targetView = targetView {
            targetView.layer.borderColor = nil
            targetView.layer.borderWidth = 0
            self.targetView = nil
        }
        clearInitialState()
    }
    
    // MARK: - Guaranteed properties
    
    func requiredDelegate(forFunction function: String) -> ComponentEditBarDelegate {
        guard let delegate = delegate else {
            fatalError("Missing delegate required for function: \(function)")
        }
        
        return delegate
    }
    func requiredComponent(forFunction function: String) -> Component {
        guard let component = component else {
            fatalError("Missing component required for function: \(function)")
        }
        
        return component
    }
    
}

// MARK: - Selector Extension

fileprivate extension Selector {
    static let saveTapped = #selector(localClass.saveTapped)
    static let cancelTapped = #selector(localClass.cancelTapped)
}

// MARK: - Callbacks

fileprivate struct Method {
    static let deleteTapped = localClass.deleteTapped
    
}
