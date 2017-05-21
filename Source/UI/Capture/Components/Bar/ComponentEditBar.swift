//
//  ComponentEditBar.swift
//  Slate
//
//  Created by John Coates on 5/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Cartography

fileprivate typealias LocalClass = ComponentEditBar

final class ComponentEditBar: UIView {
    weak var delegate: ComponentEditBarDelegate?
    
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
        setUpTitleButton()
    }
    
    let saveButton = InverseMaskButton(icon: CheckmarkIcon())
    fileprivate func setUpSaveButton() {
        saveButton.setTappedCallback(instance: self, method: Method.saveTapped)
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
        cancelButton.setTappedCallback(instance: self, method: Method.cancelTapped)
        addSubview(cancelButton)
        
        constrain(cancelButton, saveButton) { cancelButton, saveButton in
            cancelButton.size == saveButton.size
            cancelButton.top == saveButton.bottom + 2
            cancelButton.left == saveButton.left
        }
    }
    
    let titleButton = Button()
    func setUpTitleButton() {
        setUpTitleLabel()
        setUpTitleInteractivityIndicator()
        
        titleButton.setTappedCallback(instance: self, method: Method.titleTapped)
        addSubview(titleButton)
        constrain(titleButton, titleLabel, titleInteractivityIndicator) {
            titleButton, titleLabel, titleInteractivityIndicator in
            let superview = titleButton.superview!
            
            titleButton.right >= titleInteractivityIndicator.right
            titleButton.left == titleLabel.left
            titleButton.top == superview.top + 6
            titleButton.height == titleLabel.height
            titleButton.centerX == superview.centerX
        }
    }
    
    let titleLabel: UILabel = UILabel(frame: .zero)
    fileprivate func setUpTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
        titleLabel.textColor = UIColor.white
        titleButton.addSubview(titleLabel)
        
        constrain(titleLabel) {
            let superview = $0.superview!
            $0.top == superview.top
            $0.left == superview.left
        }
        setUpTitleInteractivityIndicator()
    }
    
    var titleInteractivityIndicator = CanvasIconView(icon: InteractivityIndicatorIcon())
    private func setUpTitleInteractivityIndicator() {
        titleButton.addSubview(titleInteractivityIndicator)
        
        constrain(titleInteractivityIndicator, titleLabel) { titleInteractivityIndicator, titleLabel in
            titleInteractivityIndicator.left == titleLabel.right + 4
            titleInteractivityIndicator.centerY == titleLabel.centerY + 1
            titleInteractivityIndicator.width == 11.5
            titleInteractivityIndicator.height == 3.5
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
            $0.width == LocalClass.progressControlWidth
            $0.height == $0.width
            
            $0.left >= superview.leftMargin
            $0.centerY == superview.centerY
        }
        
        setLeftConstraint(forControl: control)
        addTitleLabel(withText: settings.name, forControl: control)
        
    }

    // MARK: - Progress Control Overloads
    
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
    
    // MARK: - Delete Control
    
    func addDeleteControl() {
        let control = CodeIconButton(icon: DeleteLineIcon())
        control.rounding = 1
        control.contentView.backgroundColor = UIColor(red:0.16, green:0.14, blue:0.17, alpha:1.00)
        control.setTappedCallback(instance: self, method: Method.deleteTapped)
        addSubview(control)
        controls.append(control)
        
        let innerCircleWidth = CircleSlider.defaultInnerWidth(withOuterWidth: LocalClass.progressControlWidth)
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
    
    // MARK: - Edit Border
    
    func addEditBorder(forView view: UIView) {
        let target = borderView(forView: view)
        target.layer.borderColor = UIColor(red:0.13, green:0.55,
                                           blue:0.78, alpha:1.00).cgColor
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
    
    // MARK: - Initial State
    
    enum SupportedProperty {
        case position
        case size
        case rounding
        case opacity
    }
    
    var initialValues = [SupportedProperty: Any]()
    
    func resetToInitialState(component: Component) {
        if let target = component as? EditPosition {
            guard let value = initialValues[.position] as? CGPoint else {
                fatalError("Didn't record initial position for component: \(component)")
            }
            target.origin = value
        }
        if let target = component as? EditSize {
            guard let value = initialValues[.size] as? Float else {
                fatalError("Didn't record initial size for component: \(component)")
            }
            target.size = value
        }
        if let target = component as? EditRounding {
            guard let value = initialValues[.rounding] as? Float else {
                fatalError("Didn't record initial rounding for component: \(component)")
            }
            target.rounding = value
        }
        if let target = component as? EditOpacity {
            guard let value = initialValues[.opacity] as? Float else {
                fatalError("Didn't record initial opacity for component: \(component)")
            }
            target.opacity = value
        }
    }
    
    func clearInitialState() {
        initialValues.removeAll()
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
    
    func titleTapped() {
        print("title tapped")
        
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        let appearance = UIAlertAction(title: "Appearance", style: .default) { action in
            self.changedMode()
        }
        alertController.addAction(appearance)
        let interaction = UIAlertAction(title: "Interaction", style: .default) { action in
            self.changedMode()
        }
        alertController.addAction(interaction)
        
        let gestured = UIAlertAction(title: "Gestured", style: .default) { action in
            self.changedMode()
        }
        alertController.addAction(gestured)
        delegate?.showEditModeAlert(controller: alertController)
    }
    
    func changedMode() {
        print("new edit mode")
    }
    
    private func stopEditing() {
        isHidden = true
        if let targetView = targetView {
            resetEditBorder(forView: targetView)
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

// MARK: - Callbacks

fileprivate struct Method {
    static let saveTapped = LocalClass.saveTapped
    static let cancelTapped = LocalClass.cancelTapped
    static let deleteTapped = LocalClass.deleteTapped
    static let titleTapped = LocalClass.titleTapped
}
