//
//  ComponentEditBar.swift
//  Slate
//
//  Created by John Coates on 5/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

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
    
    let saveButton = InverseMaskButtonImage(asset: EditingImage.checkmark)
    
    fileprivate func setUpSaveButton() {
        saveButton.setTappedCallback(instance: self, method: Method.saveTapped)
        addSubview(saveButton)
        
        saveButton.width --> 35
        saveButton.height --> 35
        saveButton.top.pin(to: top, add: 15)
        saveButton.right.pin(to: right, add: -10)
    }
    
    let cancelButton = InverseMaskButtonImage(asset: EditingImage.cancel)
    fileprivate func setUpCancelButton() {
        cancelButton.setTappedCallback(instance: self, method: Method.cancelTapped)
        addSubview(cancelButton)
        
        cancelButton.size --> saveButton.size
        cancelButton.top.pin(to: saveButton.bottom, add: 2)
        cancelButton.left --> saveButton.left
    }
    
    let titleButton = Button()
    func setUpTitleButton() {
        setUpTitleLabel()
        setUpTitleInteractivityIndicator()
        
        titleButton.setTappedCallback(instance: self, method: Method.titleTapped)
        addSubview(titleButton)
        
        titleButton.right --> titleInteractivityIndicator.right
        titleButton.left --> titleLabel.left
        titleButton.top.pin(to: top, add: 6)
        titleButton.height --> titleLabel.height
        titleButton.centerX --> centerX
    }
    
    let titleLabel: UILabel = UILabel(frame: .zero)
    fileprivate func setUpTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
        titleLabel.textColor = UIColor.white
        titleButton.addSubview(titleLabel)
        
        titleLabel.top --> titleButton.top
        titleLabel.left --> titleButton.left
        
        setUpTitleInteractivityIndicator()
    }
    
    var titleInteractivityIndicator = CanvasIconView(icon: InteractivityIndicatorIcon())
    private func setUpTitleInteractivityIndicator() {
        titleButton.addSubview(titleInteractivityIndicator)
        
        titleInteractivityIndicator.left.pin(to: titleLabel.right, add: 4)
        titleInteractivityIndicator.centerY.pin(to: titleLabel.centerY, add: 1)
        titleInteractivityIndicator.width --> 11.5
        titleInteractivityIndicator.height --> 3.5
    }
    
    // MARK: - Progress Controls
    
    var lastEditControl: UIView?
    var controls = [UIView]()
    
    // MARK: - Delete Control
    
    func addDeleteControl() {
//        let control = CodeIconButton(icon: DeleteLineIcon())
        let control = PathsImageButton(asset: EditingImage.delete)
        control.rounding = 1
        control.contentView.backgroundColor = UIColor(red:0.16, green:0.14, blue:0.17, alpha:1.00)
        control.setTappedCallback(instance: self, method: Method.deleteTapped)
        addSubview(control)
        controls.append(control)
        
        let innerCircleWidth = CircleSlider.defaultInnerWidth(withOuterWidth: LocalClass.progressControlWidth)
        control.width --> innerCircleWidth
        control.height --> control.width
        
        control.left -->+= leftMargin
        control.centerY --> centerY
        
        setLeftConstraint(forControl: control)
        addTitleLabel(withText: "Delete", forControl: control)
    }
    
    // MARK: - Control Utilities
    
    func setLeftConstraint(forControl control: UIView) {
        if let lastEditControl = lastEditControl {
            control.left.pin(to: lastEditControl.right, add: 20)
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
        
        label.centerX --> control.centerX
        label.bottom.pin(to: bottom, add: -9)
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
