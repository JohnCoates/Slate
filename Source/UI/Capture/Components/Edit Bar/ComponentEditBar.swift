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

class ComponentEditBar: UIView {
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
    
    var lastEditControl: UIView?
    var controls = [UIView]()
    
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
    
    // MARK: - Initial State
    
    var initialValues = [SupportedProperty: Any]()
    
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
        
        let gestured = UIAlertAction(title: "Gestures", style: .default) { action in
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
