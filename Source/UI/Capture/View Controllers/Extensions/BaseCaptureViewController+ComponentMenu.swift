//
//  BaseCaptureViewController+ComponentMenu.swift
//  Slate
//
//  Created by John Coates on 5/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

private typealias LocalClass = BaseCaptureViewController
extension BaseCaptureViewController: ComponentMenuBarDelegate {
    
    func controlMenuSetup() {
        menuView.delegate = self
//        let blurEffect = UIBlurEffect(style: .light)
//        let visualEffectView = UIVisualEffectView(effect: blurEffect)
//        menuView.addSubview(visualEffectView)
//        visualEffectView.edges --> menuView.edges
        
        menuView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        view.addSubview(menuView)
        
        menuView.left --> view.left
        menuView.height --> 55
        menuView.width --> view.width
        menuView.top -->+= view.top
        menuView.bottom -->-= view.bottom
        menuVerticalConstraint = menuView.top.pin(to: view.top, add: 100, rank: .low)
        menuDraggableSetup()
    }
    
    func menuDraggableSetup() {
        menuView.addGestureRecognizer(dragGesture)
    }
    
    @objc func menuDragged(gesture: UIPanGestureRecognizer) {
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
             atFrame frame: CGRect, fromView: UIView) {
        let componentInstance = component.createInstance()
        let componentView = componentInstance.view
        componentInstance.frame = fromView.convert(frame, to: view)
        
        view.insertSubview(componentView, belowSubview: menuView)
        
        kit.addComponent(component: componentInstance)
        kit.save()
        
        configureAdded(component: componentInstance)
    }
    
}
