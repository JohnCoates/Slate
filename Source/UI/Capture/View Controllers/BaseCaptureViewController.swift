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

fileprivate typealias localVC = BaseCaptureViewController
class BaseCaptureViewController: UIViewController,
DebugBarDelegate, UIGestureRecognizerDelegate, ComponentMenuBarDelegate,
ComponentEditBarDelegate {
    
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
    
    // MARK: - Component Menu Setup
    
    fileprivate lazy var menuView = ComponentMenuBar()
    fileprivate var menuVerticalConstraint: NSLayoutConstraint?
    fileprivate func controlMenuSetup() {
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
    
    // MARK: - Debug Bar
    
    var barItems: [DebugBarItem] {
        let jitterKey = DebugBarItem(title: "Jitter")
        jitterKey.tapClosure = {
            self.captureButton.startKeyTimesJitter()
        }
        
        let stopJitter = DebugBarItem(title: "Stop Jittter")
        stopJitter.tapClosure = {
            self.captureButton.stopJittter()
        }
        return [jitterKey, stopJitter]
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
        
        addEditGesture(toComponent: componentInstance)
    }
    
    // MARK: - Load Kit
    
    func loadComponents() {
        for component in kit.components {
            component.view.frame = component.frame
            self.view.insertSubview(component.view, belowSubview: menuView)
            addEditGesture(toComponent: component)
        }
        print("all components: \(kit.components)")
    }
    
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
        
        for component in kit.components {
            if targetView == component.view {
                configureEditBar(withTargetComponent: component)
                // remove hold to edit gesture
                targetView.removeGestureRecognizer(gesture)
                return
            }
        }
        
        fatalError("Edit gesture failed")
    }
    
    // MARK: - Edit Components
    
    lazy var editBar = ComponentEditBar()
    fileprivate var editBarVerticalConstraint: NSLayoutConstraint?
    fileprivate func componentEditBarSetup() {
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
    
    fileprivate lazy var editBarDragGesture: UIPanGestureRecognizer = {
        let dragGesture = UIPanGestureRecognizer(target: self,
                                                 action: .editBarDragged)
        dragGesture.delegate = self
        return dragGesture
    }()
    
    fileprivate func editBarDraggableSetup() {
        editBar.addGestureRecognizer(editBarDragGesture)
    }
    
    fileprivate var editBarLastTranslationY: CGFloat?
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
    
    fileprivate func configureEditBar(withTargetComponent target: Component) {
        editBar.isHidden = false
        editBar.set(target: target)
        
        editGestures.removeAll()
        if target is EditPosition {
            addPositionEditGesture(toComponent: target)
        }
    }
    
    // MARK: - Edit Position
    
    var editGestures = [DragGesture]()
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
}

extension Realm {
    func filter<ParentType: Object>(parentType: ParentType.Type,
                subclasses: [ParentType.Type], predicate: NSPredicate) -> [ParentType] {
        return ([parentType] + subclasses).flatMap { classType in
            return Array(self.objects(classType).filter(predicate))
        }
    }
}
// MARK: - Callbacks

private struct Method {
    static let captureTapped = BaseCaptureViewController.captureTapped
}

// MARK: - Selector Extension

fileprivate extension Selector {
    static let menuDragged = #selector(localVC.menuDragged)
    static let editBarDragged = #selector(localVC.editBarDragged)
    static let controlWasLongPressed = #selector(localVC.controlWasLongPressed)
    static let componentEditGesture = #selector(localVC.componentEditGesture)
}
