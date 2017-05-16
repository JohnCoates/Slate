//
//  PermissionsWindow.swift
//  Slate
//
//  Created by John Coates on 5/16/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography

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
        
        let completion = { (completed: Bool) -> Void in
//            DispatchQueue.main.asyncAfter(deadline: .now() + length) {
//                dismiss()
//            }
        }
        
        if !animated {
            animations()
            completion(true)
            return
        }
        
        let animationOptions: UIViewAnimationOptions = [.curveLinear]
        
        UIView.animate(withDuration: 0.3, delay: 0,
                       options: animationOptions,
                       animations: animations,
                       completion: completion)
    }
    
    class func dismiss() {
        guard let window = currentWindow else {
            return
        }
        
        let animationOptions: UIViewAnimationOptions = [.curveLinear]
        let animations = {
            window.alpha = 0
        }
        let completion = { (completed: Bool) in
            window.isHidden = true
            if window == currentWindow {
                currentWindow = nil
            }
        }
        
        UIView.animate(withDuration: 0.45, delay: 0,
                       options: animationOptions,
                       animations: animations,
                       completion: completion)
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
