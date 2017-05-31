//
//  CameraPreviewViewController.swift
//  Slate
//
//  Created by John Coates on 5/30/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Cocoa
import MetalKit

class CameraPreviewViewController: NSViewController {

    let metalView = MTKView()
    lazy var renderer: Renderer = Renderer(metalView: self.metalView)!
    lazy var hudController: HUDController = HUDController(renderer: self.renderer)
    
    override func loadView() {
        view = NSView()
        view.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
        metalView.frame = view.bounds
        view.addSubview(metalView)
        hudController.showWindow(nil)
    }
    
}
