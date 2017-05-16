//
//  BaseCaptureViewController.swift
//  Slate
//
//  Created by John Coates on 9/30/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit
import Cartography
import RealmSwift

#if (arch(i386) || arch(x86_64)) && os(iOS)
    typealias CaptureViewController = SimulatorCaptureViewController
#else
    typealias CaptureViewController = MetalCaptureViewController
#endif

fileprivate typealias LocalClass = BaseCaptureViewController
class BaseCaptureViewController: UIViewController, UIGestureRecognizerDelegate {
    
    lazy var kit: Kit = { KitManager.currentKit }()
    
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
        
        loadComponents()
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
        componentEditBarSetup()
    }
    
    // MARK: - Capture Button Setup
    
    lazy var captureButton: CaptureButton = CaptureButton()
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
    
    // MARK: - Component Menu Setup
    
    lazy var menuView = ComponentMenuBar()
    var menuVerticalConstraint: NSLayoutConstraint?
    
    lazy var dragGesture: UIPanGestureRecognizer = {
        let dragGesture = UIPanGestureRecognizer(target: self,
                                                 action: .menuDragged)
        dragGesture.delegate = self
        return dragGesture
    }()
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == dragGesture {
            return isVerticalDrag(gesture: dragGesture, targetView: menuView)
        } else if gestureRecognizer == editBarDragGesture {
            return isVerticalDrag(gesture: editBarDragGesture, targetView: editBar)
        }
        
        return false
    }
    
    func isVerticalDrag(gesture: UIPanGestureRecognizer,
                        targetView: UIView) -> Bool {
        let velocity = gesture.velocity(in: targetView)
        if abs(velocity.y) > abs(velocity.x) {
            return true
        } else {
            return false
        }
    }
    
    var menuLastTranslationY: CGFloat?
    
    // MARK: - Status Bar
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Editable Controls
    
    var editingControls = false {
        didSet {
            if editingControls {
                captureButton.startKeyTimesJitter()
            } else {
                captureButton.stopJittter()
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
    
    // MARK: - Load Kit
    
    func loadComponents() {
        for component in kit.components {
            component.view.frame = component.frame
            self.view.insertSubview(component.view, belowSubview: menuView)
            configureAdded(component: component)
        }
    }
    
    // MARK: - Component Configuring
    
    func configureAdded(component: Component) {
        addEditGesture(toComponent: component)
        
        if let componentView = component.view as? FrontBackCameraToggle {
            componentView.setTappedCallback(instance: self, method: Method.switchCamera)
        }
    }
    
    // MARK: - Edit Components
    
    lazy var editBar = ComponentEditBar()
    var editBarVerticalConstraint: NSLayoutConstraint?
    
    lazy var editBarDragGesture: UIPanGestureRecognizer = {
        let dragGesture = UIPanGestureRecognizer(target: self,
                                                 action: .editBarDragged)
        dragGesture.delegate = self
        return dragGesture
    }()
    
    var editBarLastTranslationY: CGFloat?
    
    // MARK: - Edit Position
    
    var editGestures = [DragGesture]()
    
    // MARK: - Camera Actions
    
    func switchCamera() {
        print("Switch camera!")
    }
    
    func captureTapped() {
        print("capture tapped")
    }
}

// MARK: - Callbacks

private struct Method {
    static let captureTapped = LocalClass.captureTapped
    static let switchCamera = LocalClass.switchCamera
}

// MARK: - Selector Extension

fileprivate extension Selector {
    static let menuDragged = #selector(LocalClass.menuDragged)
    static let editBarDragged = #selector(LocalClass.editBarDragged)
    static let controlWasLongPressed = #selector(LocalClass.controlWasLongPressed)
    static let componentEditGesture = #selector(LocalClass.componentEditGesture)
}
