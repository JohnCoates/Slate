//
//  BaseCaptureViewController+ComponentEditing.swift
//  Slate
//
//  Created by John Coates on 5/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography

fileprivate typealias LocalClass = BaseCaptureViewController
extension BaseCaptureViewController: ComponentEditBarDelegate {
    
    // MARK: - Edit Bar
    
    func componentEditBarSetup() {
        view.addSubview(editBar)
        var verticalConstraint: NSLayoutConstraint!
        constrain(editBar) {
            let superview = $0.superview!
            $0.left == superview.left
            $0.height == 100
            $0.width == superview.width
            $0.top >= superview.top ~ 1000
            $0.bottom <= superview.bottom ~ 1000
            verticalConstraint = $0.top == superview.top + 300
            verticalConstraint ~ 400
        }
        editBar.delegate = self
        editBar.isHidden = true
        editBarVerticalConstraint = verticalConstraint
        editBarDraggableSetup()
    }
    
    func editBarDraggableSetup() {
        editBar.addGestureRecognizer(editBarDragGesture)
    }
    
    func editBarDragged(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .ended || gesture.state == .cancelled {
            editBarLastTranslationY = nil
        }
        guard gesture.state == .changed else {
            return
        }
        
        let translation = gesture.translation(in: editBar)
        var translationY = translation.y
        
        if let editBarLastTranslationY = editBarLastTranslationY {
            translationY -= editBarLastTranslationY
        }
        
        let minimumOffsetChange: CGFloat = 1
        guard abs(translationY) > minimumOffsetChange,
            let editBarVerticalConstraint = editBarVerticalConstraint else {
                return
        }
        
        editBarLastTranslationY = translation.y
        
        editBarVerticalConstraint.constant += translationY
        editBar.setNeedsLayout()
    }
    
    fileprivate func loadComponentEditBar() {
        let editControl = CircleSlider()
        self.view.addSubview(editControl)
        
        constrain(editControl) {
            let superview = $0.superview!
            $0.center == superview.center
            $0.width == 50
            $0.height == $0.width
        }
    }
    
    func configureEditBar(withTargetComponent target: Component) {
        editBar.isHidden = false
        editBar.set(target: target)
        
        editGestures.removeAll()
        if target is EditPosition {
            addPositionEditGesture(toComponent: target)
        }
    }

    // MARK: - Component Edit Bar Delegate
    
    func cancel(editingComponent: Component) {
        editGestures.removeAll()
        addEditGesture(toComponent: editingComponent)
    }
    
    func save(component: Component) {
        editGestures.removeAll()
        addEditGesture(toComponent: component)
        kit.saveKit()
    }
    
    func askUserForDeleteConfirmation(component: Component,
                                      userConfirmedBlock: @escaping ComponentEditBarDelegate.UserConfirmedDeleteBlock) {
        let alertController = UIAlertController(title: "Delete Component",
                                                message: "Are you sure you want to delete this component?",
                                                preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancel)
        
        let kit = self.kit
        let delete = UIAlertAction(title: "Delete", style: .destructive) { action in
            userConfirmedBlock(true)
            self.editGestures.removeAll()
            component.view.removeFromSuperview()
            guard let index = kit.components.index(where: {$0 === component}) else {
                fatalError("Couldn't find component to delete: \(component)")
            }
            kit.components.remove(at: index)
            kit.saveKit()
        }
        alertController.addAction(delete)
        
        present(alertController, animated: true, completion: nil)
    }

    func showEditModeAlert(controller: UIAlertController) {
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Edit Position
    
    func addPositionEditGesture(toComponent targetComponent: Component) {
        guard let component = targetComponent as? EditPosition else {
            return
        }
        
        let gesture = DragGesture(withView: targetComponent.view)
        editGestures.append(gesture)
        gesture.dragHandler = { difference in
            var origin = component.origin
            origin.x += difference.x
            origin.y += difference.y
            component.origin = origin
        }
    }
    
    // MARK: - Edit Gestures
    
    func addEditGesture(toComponent component: Component) {
        let gesture = UILongPressGestureRecognizer(target: self, action: .componentEditGesture)
        component.view.addGestureRecognizer(gesture)
    }
    
    func componentEditGesture(gesture: UILongPressGestureRecognizer) {
        guard let targetView = gesture.view else {
            fatalError("No view associated with gesture!")
        }
        
        guard gesture.state == .began else {
            return
        }
        
        for component in kit.components where targetView == component.view {
            configureEditBar(withTargetComponent: component)
            // remove hold to edit gesture
            targetView.removeGestureRecognizer(gesture)
            return
        }
        
        fatalError("Edit gesture failed")
    }
}

// MARK: - Selector Extension

fileprivate extension Selector {
    static let menuDragged = #selector(LocalClass.menuDragged)
    static let editBarDragged = #selector(LocalClass.editBarDragged)
    static let componentEditGesture = #selector(LocalClass.componentEditGesture)
}
