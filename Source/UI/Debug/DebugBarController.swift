//
//  DebugBarController.swift
//  Slate
//
//  Created by John Coates on 12/28/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation

class DebugBarController: NSObject {
    
    static let sharedInstance = DebugBarController()
    
    // MARK: - Setup
    
    override init() {
        super.init()
        draggableBarSetup()
    }
    
    // MARK: - Activation
    
    var activated = false
    func toggleActivation() {
        guard !activated else {
            activated = false
            barView.removeFromSuperview()
            return
        }
        activated = true
        
        guard let viewController = topMostViewController else {
            return
        }
        
        let width = Int(viewController.view.bounds.width)
        let height = 50
        barView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        viewController.view.addSubview(barView)
        
        guard let barDelegate = viewController as? DebugBarDelegate else {
            return
        }
        
        barView.items = barDelegate.barItems
    }
    
    // MARK: - Bar
    
    var barView = DebugBarView()
    
    // MARK: - Bar Dragging
    
    func draggableBarSetup() {
        let dragGesture = UIPanGestureRecognizer(target: self,
                                                 action: .barDragged)
        barView.addGestureRecognizer(dragGesture)
    }
    
    fileprivate var dragLastTranslationY: CGFloat?
    func barDragged(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .ended || gesture.state == .cancelled {
            dragLastTranslationY = nil
        }
        guard gesture.state == .changed else {
            return
        }
        
        let translation = gesture.translation(in: barView)
        var translationY = translation.y
        
        if let dragLastTranslationY = dragLastTranslationY {
            translationY -= dragLastTranslationY
        }
        
        let minimumOffsetChange: CGFloat = 1
        guard abs(translationY) > minimumOffsetChange,
            let superview = barView.superview else {
                return
        }
        
        dragLastTranslationY = translation.y
        var originY = barView.frame.minY + translationY
        let maxY = superview.frame.height - barView.frame.height
        originY = max(originY, 0)
        originY = min(originY, maxY)
        barView.frame.origin.y = originY
        
        barView.setNeedsLayout()
    }
    
    // MARK: - Utility
    
    var topMostViewController: UIViewController? {
        guard let window = UIApplication.shared.keyWindow else {
            return nil
        }
        
        var topMost = window.rootViewController
        while let child = topMost?.presentedViewController {
            topMost = child
        }
        
        return topMost
    }
}

// MARK: - Selector Extension

private extension Selector {
    static let barDragged = #selector(DebugBarController.barDragged)
}
