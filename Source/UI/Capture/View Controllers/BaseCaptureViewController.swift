//
//  BaseCaptureViewController.swift
//  Slate
//
//  Created by John Coates on 9/30/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit
import Cartography

class BaseCaptureViewController: UIViewController,
DebugBarDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "CaptureView"
        view.backgroundColor = UIColor.black
        controlsSetup()
        
        if Platform.isSimulator {
            placeholderSetup()
        } else {
            cameraSetup()
        }
    }
    
    // MARK: - Setup
    
    func cameraSetup() {
        fatalError("\(#file) cameraSetup() must be subclassed")
    }
    
    // MARK: - Placeholder
    
    fileprivate func placeholderSetup() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "HannahDeathValley"))
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.insertSubview(imageView, at: 0)
    }
    
    // MARK: - Controls Setup
    
    fileprivate func controlsSetup() {
        captureButtonSetup()
        controlMenuSetup()
    }
    
    // MARK: - Capture Button Setup
    
    private lazy var captureButton: CaptureButton = CaptureButton()
    fileprivate func captureButtonSetup() {
        captureButton.setTappedCallback(instance: self,
                                        method: Method.captureTapped)
        addLongPressGesture(toControl: captureButton)
        view.addSubview(captureButton)
        
        constrain(captureButton) {
            let superview = $0.superview!
            $0.width == 75
            $0.height == $0.width
            $0.centerX == superview.centerX
            $0.bottom == superview.bottom - 15
        }
    }
    
    // MARK: - Control Menu Setup
    
    fileprivate lazy var menuView = ControlsMenuBar()
    fileprivate var menuVerticalConstraint: NSLayoutConstraint?
    fileprivate func controlMenuSetup() {
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
    
    lazy var dragGesture: UIPanGestureRecognizer = {
        let dragGesture = UIPanGestureRecognizer(target: self,
                                                 action: .menuDragged)
        dragGesture.delegate = self
        return dragGesture
    }()
    
    fileprivate func menuDraggableSetup() {
        menuView.addGestureRecognizer(dragGesture)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == dragGesture {
            return menuIsBeingDraggedVertically()
        }
        
        return false
    }
    
    func menuIsBeingDraggedVertically() -> Bool {
        let velocity = dragGesture.velocity(in: menuView)
        if abs(velocity.y) > abs(velocity.x) {
            return true
        } else {
            return false
        }
    }
    
    fileprivate var menuLastTranslationY: CGFloat?
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
    
    // MARK: - Capturing
    
    func captureTapped() {
        print("capture tapped")
    }
    
    // MARK: - Status Bar
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    // MARK: - Editable Controls
    
    var editingControls = false {
        didSet {
            if editingControls {
                self.captureButton.startFrameIntervalJitter()
            } else {
                self.captureButton.stopJittter()
            }
        }
    }
    
    func addLongPressGesture(toControl control: UIView) {
        let longPress = UILongPressGestureRecognizer(target: self, action: .controlWasLongPressed)
        control.addGestureRecognizer(longPress)
    }
    
    func controlWasLongPressed(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            editingControls = !editingControls
        }
    }
    
    // MARK: - Debug Bar
    
    var barItems: [DebugBarItem] {
        let jitterKey = DebugBarItem(title: "Jitter keyTimes")
        jitterKey.tapClosure = {
            self.captureButton.startKeyTimesJitter()
        }
        let jitterFrame = DebugBarItem(title: "Jitter frameInterval")
        jitterFrame.tapClosure = {
            self.captureButton.startFrameIntervalJitter()
        }
        
        let stopJitter = DebugBarItem(title: "Stop Jittter")
        stopJitter.tapClosure = {
            self.captureButton.stopJittter()
        }
        return [jitterKey, jitterFrame, stopJitter]
    }
}

// MARK: - Callbacks

private struct Method {
    static let captureTapped = BaseCaptureViewController.captureTapped
    
}

// MARK: - Selector Extension

private extension Selector {
    static let menuDragged = #selector(BaseCaptureViewController.menuDragged)
    static let controlWasLongPressed = #selector(BaseCaptureViewController.controlWasLongPressed(gesture:))
}
