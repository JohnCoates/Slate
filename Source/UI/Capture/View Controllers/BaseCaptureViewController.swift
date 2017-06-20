//
//  BaseCaptureViewController.swift
//  Slate
//
//  Created by John Coates on 9/30/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit

#if (arch(i386) || arch(x86_64)) && os(iOS)
    typealias CaptureViewController = SimulatorCaptureViewController
#else
    typealias CaptureViewController = MetalCaptureViewController
#endif

fileprivate typealias LocalClass = BaseCaptureViewController
class BaseCaptureViewController: UIViewController, UIGestureRecognizerDelegate, PermissionsManagerDelegate {
    
    let kit: Kit
    
    // MARK: - Init
    
    convenience init() {
        self.init(kit: KitManager.currentKit)
    }
    
    required init(kit: Kit) {
        self.kit = kit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        Critical.methodNotDefined()
    }
    
    var permissionsManager: PermissionsManager?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // prevents UICollectionView insets from being increased
        automaticallyAdjustsScrollViewInsets = false
        view.accessibilityIdentifier = "CaptureView"
        view.backgroundColor = .black
        controlsSetup()
        
        if hasCameraPermissions {
            cameraSetup()
            loadComponents()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestCameraPermissionsIfNecessary()
    }
    
    // MARK: - View Layout Behavior
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layOutComponents()
    }
    
    // MARK: - View Rotation
    
    var keepUpright = [UIView]()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let oldBounds = view.bounds
        coordinator.animate(alongsideTransition: { context in
            self.rootViewUpdateBounds(oldBounds: oldBounds, targetSize: size)
            self.rootViewApplyRotationCorrectingTransform(targetTransform: context.targetTransform)
            self.applyUprightTransformToSubscribedViews()
            
            let orientation = UIScreen.orientation
            self.transitionKit(to: size, orientation: orientation)
            
            self.view.layoutIfNeeded()
        }) { context in
            self.rootViewRoundTransformNowThatAnimationFinished()
        }
    }
    
    // MARK: - Setup
    
    func cameraSetup() {
        fatalError("\(#file) cameraSetup() must be subclassed")
    }
    
    // MARK: - Controls Setup
    
    func controlsSetup() {
        controlMenuSetup()
        componentEditBarSetup()
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
    
    // MARK: - Load Kit
    
    func loadComponents() {
        for component in kit.components {
            self.view.insertSubview(component.view, belowSubview: menuView)
            configureAdded(component: component)
        }
        
        view.setNeedsLayout()
    }
    
    // MARK: - Component Configuring
    
    func configureAdded(component: Component) {
        addEditGesture(toComponent: component)
        
        if let componentView = component.view as? SwitchCameraButton {
            componentView.setTappedCallback(instance: self,
                                            method: Method.switchCamera)
        } else if let componentView = component.view as? CaptureButton {
            componentView.setTappedCallback(instance: self,
                                            method: Method.capture)
        }
    }
    
    func layOutComponents() {
        for component in kit.components {
            performLayout(forComponent: component)
        }
    }
    
    func performLayout(forComponent component: Component) {
        component.view.frame = component.frame
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
    
    func capture() {
        print("capture tapped")
    }
    
    func switchCamera() {
        print("Switch camera!")
    }
    
    // MARK: - Permissions
    
    var hasCameraPermissions: Bool {
        let permissionsManager = PermissionsManager()
        return permissionsManager.hasPermission(for: .camera)
    }
    
    func requestCameraPermissionsIfNecessary() {
        let permissionsManager = PermissionsManager()
        if hasCameraPermissions == false {
            if permissionsManager.hasAvailableRequest(for: .camera) {
                self.permissionsManager = permissionsManager
                permissionsManager.delegate = self
                permissionsManager.requestPermission(for: .camera)
            } else {
                PermissionsWindow.show(kind: .cameraDenied, animated: true)
            }
        }
    }
    
    // MARK: - Permissions Manager Delegate
    
    func enabled(permission: Permission) {
        if permission == .camera {
            cameraSetup()
            loadComponents()
        }
    }
    
    func denied(permission: Permission) {
    }
    
}

// MARK: - Callbacks

private struct Method {
    static let switchCamera = LocalClass.switchCamera
    static let capture = LocalClass.capture
}

// MARK: - Selector Extension

fileprivate extension Selector {
    static let menuDragged = #selector(LocalClass.menuDragged)
    static let editBarDragged = #selector(LocalClass.editBarDragged)
    static let componentEditGesture = #selector(LocalClass.componentEditGesture)
}
