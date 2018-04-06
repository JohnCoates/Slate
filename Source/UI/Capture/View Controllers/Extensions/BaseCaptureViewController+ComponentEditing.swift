//
//  BaseCaptureViewController+ComponentEditing.swift
//  Slate
//
//  Created by John Coates on 5/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

private typealias LocalClass = BaseCaptureViewController
extension BaseCaptureViewController: ComponentEditBarDelegate {
    
    // MARK: - Edit Bar
    
    func componentEditBarSetup() {
        view.addSubview(editBar)
        editBar.left --> view.left
        editBar.height --> 100
        editBar.width --> view.width
        editBar.top -->+= view.top
        editBar.bottom -->-= view.bottom
        editBarVerticalConstraint = editBar.top.pin(to: view.top, add: 300, rank: 400)
        
        editBar.delegate = self
        editBar.isHidden = true
        
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
        view.addSubview(editControl)
        
        editControl.centerXY --> view.centerXY
        editControl.width --> 50
        editControl.height --> editControl.width
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
        
        let targetView = targetComponent.view
        let gesture = DragGesture(withView: targetView)
        editGestures.append(gesture)
        gesture.dragHandler = { difference in
            let transformedDifference = difference.applying(targetView.transform)
            var center = component.center
            center.x += transformedDifference.x
            center.y += transformedDifference.y
            
            component.center = center
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
