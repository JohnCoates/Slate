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
    
    override func performLayout(forComponent component: Component) {
//        component.view.frame.origin = CGPoint(x: 0, y: 0)
//        component.view.frame.size = layoutScale.convert(size: component.frame.size)
        component.view.frame = layoutScale.convert(rect: component.frame)
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
