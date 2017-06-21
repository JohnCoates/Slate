//
//  LayoutPreviewCaptureViewController.swift
//  Slate
//
//  Created by John Coates on 6/19/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

final class LayoutPreviewCaptureViewController: BaseCaptureViewController {
    
    // MARK: - View Layout Behavior
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshLayoutScale()
    }
    
    // MARK: - Layout Scale
    
    lazy var layoutScale: LayoutScale = {
       return LayoutScale(size: Size(self.view.frame.size),
                          nativeSize: self.kit.nativeSize)
    }()
    
    func refreshLayoutScale() {
        let viewSize = view.frame.size
        layoutScale = LayoutScale(size: Size(viewSize), nativeSize: kit.nativeSize)
    }
    
    // MARK: - Lay Out Components
    
    var componentConstraints = [NSLayoutConstraint]()
    
    override func layOutComponents() {
        if componentConstraints.count > 0 {
            NSLayoutConstraint.deactivate(componentConstraints)
            componentConstraints.removeAll()
        }
        
        super.layOutComponents()
    }
    
    override func performLayout(forComponent component: Component) {
        
        if let smartLayout = component as? EditSmartLayout,
            let smartPin = smartLayout.smartPin {
            let size = layoutScale.convert(rect: component.frame).size
            performLayout(forView: component.view, withSmartPin: smartPin, size: size)
        } else {
            component.view.frame = layoutScale.convert(rect: component.frame)
        }
        
    }
    
    func performLayout(forView nativeView: UIView,
                       withSmartPin smartPin: SmartPin, size: CGSize) {
        let constraints = smartPin.apply(nativeView: nativeView,
                                         foreignView: view, scale: layoutScale)
        let widthConstraint = nativeView.width.pin(to: size.width)
        let heightConstraint = nativeView.height.pin(to: size.height)
        
        componentConstraints += constraints
        componentConstraints += [widthConstraint, heightConstraint]
    }
    
    // MARK: - Camera Setup
    
    override func cameraSetup() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "HannahDeathValley"))
        imageView.contentMode = .scaleAspectFill
        view.insertSubview(imageView, at: 0)
        imageView.edges --> view.edges
    }
    
    // MARK: - Controls Setup
    
    override func controlsSetup() {}
    
    // MARK: - Capturing
    
    override func capture() {
        print("preview capture tapped")
    }
    
    // MARK: - Permissions
    
    override var hasCameraPermissions: Bool { return true }
    
}
