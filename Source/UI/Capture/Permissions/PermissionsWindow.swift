//
//  PermissionsWindow.swift
//  Slate
//
//  Created by John Coates on 5/16/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

fileprivate typealias LocalClass = PermissionsWindow
class PermissionsWindow: UIWindow {
    
    fileprivate static var currentWindow: LocalClass?
    
    enum Kind {
        case camera
        case cameraDenied
        case photos
        case photosDenied
    }
    
    class func show(kind: Kind, animated: Bool, delegate: PermissionsManagerDelegate? = nil) {
        let window: LocalClass
        if let currentWindow = currentWindow {
            window = currentWindow
            if let delegate = delegate {
                window.delegate = delegate
            }
        } else {
            window = LocalClass(kind: kind, delegate: delegate)
        }
        
        currentWindow = window
        window.alpha = 0
        window.isHidden = false
        let animations = {
            window.alpha = 1
        }
        
        if !animated {
            animations()
            return
        }
        
        let animationOptions: UIViewAnimationOptions = [.curveLinear]
        
        UIView.animate(withDuration: 0.25, delay: 0,
                       options: animationOptions,
                       animations: animations,
                       completion: nil)
    }
    
    class func dismiss() {
        guard let window = currentWindow else {
            return
        }
        
        window.isHidden = true
        currentWindow = nil
    }
    
    // MARK: - Init
    
    let kind: Kind
    weak var delegate: PermissionsManagerDelegate?
    init(kind: Kind, delegate: PermissionsManagerDelegate? = nil) {
        self.kind = kind
        self.delegate = delegate
        super.init(frame: UIScreen.main.bounds)
        initialSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("coder: not implemented")
    }
    
    // MARK: - Setup
    
    let contentView = UIView()
    
    func initialSetup() {
        windowLevel = UIWindowLevelAlert + 1
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        rootViewController = createViewController()
    }
    
    func createViewController() -> UIViewController {
        switch kind {
        case .camera:
            return CameraPermissionViewController(delegate: delegate)
        case .cameraDenied:
            return CameraDeniedPermisionViewController()
        case .photos:
            return PhotosPermissionViewController(delegate: delegate)
        case .photosDenied:
            return PhotosDeniedPermisionViewController()
        }
    }

}
