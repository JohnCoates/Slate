//
//  BaseCaptureViewController+ComponentMenu.swift
//  Slate
//
//  Created by John Coates on 5/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography

fileprivate typealias LocalClass = BaseCaptureViewController
extension BaseCaptureViewController: ComponentMenuBarDelegate {
    
    func controlMenuSetup() {
        menuView.delegate = self
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        menuView.addSubview(visualEffectView)
        constrain(visualEffectView) {
            let superview = $0.superview!
            $0.edges == superview.edges
        }
        
        menuView.backgroundColor = UIColor.clear
        view.addSubview(menuView)
        
        var verticalConstraint: NSLayoutConstraint!
        constrain(menuView) {
            let superview = $0.superview!
            $0.left == superview.left
            $0.height == 55
            $0.width == superview.width
            $0.top >= superview.top ~ 1000
            $0.bottom <= superview.bottom ~ 1000
            verticalConstraint = $0.top == superview.top + 100
            verticalConstraint ~ 400
        }
        
        menuVerticalConstraint = verticalConstraint
        menuDraggableSetup()
    }
    
    func menuDraggableSetup() {
        menuView.addGestureRecognizer(dragGesture)
    }
    
    func menuDragged(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .ended || gesture.state == .cancelled {
            menuLastTranslationY = nil
        }
        guard gesture.state == .changed else {
            return
        }
        
        let translation = gesture.translation(in: menuView)
        var translationY = translation.y
        
        if let menuLastTranslationY = menuLastTranslationY {
            translationY -= menuLastTranslationY
        }
        
        let minimumOffsetChange: CGFloat = 1
        guard abs(translationY) > minimumOffsetChange,
            let menuVerticalConstraint = menuVerticalConstraint else {
                return
        }
        
        menuLastTranslationY = translation.y
        
        menuVerticalConstraint.constant += translationY
        menuView.setNeedsLayout()
    }
    
    // MARK: - Component Menu Bar Delegate
    
    func add(component: Component.Type,
             atFrame frame: CGRect, fromView view: UIView) {
        let componentInstance = component.createInstance()
        let componentView = componentInstance.view
        componentInstance.frame = view.convert(frame, to: self.view)
        
        self.view.insertSubview(componentView, belowSubview: menuView)
        
        kit.addComponent(component: componentInstance)
        kit.saveKit()
        
        configureAdded(component: componentInstance)
    }
}
