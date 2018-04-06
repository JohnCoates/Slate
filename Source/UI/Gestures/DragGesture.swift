//
//  DragGesture.swift
//  Slate
//
//  Created by John Coates on 5/12/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

private typealias LocalClass = DragGesture

@objc class DragGesture: NSObject {
    fileprivate let gesture = UIPanGestureRecognizer.init()
    
    var dragHandler: ((_ difference: CGPoint) -> Void)?
    let targetView: UIView
    
    init(withView view: UIView) {
        targetView = view
        super.init()
        attach()
    }
    
    deinit {
        detach()
    }
    
    fileprivate func attach() {
        targetView.addGestureRecognizer(gesture)
        gesture.addTarget(self, action: .dragged)
    }
    func detach() {
        targetView.removeGestureRecognizer(gesture)
    }
    
    fileprivate var lastTranslation: CGPoint?
    @objc func dragged(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .ended || gesture.state == .cancelled {
            lastTranslation = nil
        }
        guard gesture.state == .changed else {
            return
        }
        
        let translation = gesture.translation(in: targetView)
        var difference = CGPoint.zero
        
        if let lastTranslation = lastTranslation {
            difference.y = translation.y - lastTranslation.y
            difference.x = translation.x - lastTranslation.x
            dragHandler?(difference)
        }
        
        lastTranslation = translation
    }
}

// MARK: - Selector Extension

fileprivate extension Selector {
    static let dragged = #selector(LocalClass.dragged)
}
