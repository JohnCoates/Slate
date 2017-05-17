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
    
    class func show(animated: Bool, length: Double = 1) {
        let window: LocalClass
        if let currentWindow = currentWindow {
            window = currentWindow
        } else {
            window = LocalClass()
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
        
        UIView.animate(withDuration: 0.3, delay: 0,
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
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialSetup()
    }
    
    // MARK: - Setup
    
    let contentView = UIView()
    func initialSetup() {
        windowLevel = UIWindowLevelAlert + 1
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        rootViewController = CameraRollPermissionsViewController()
    }

}
