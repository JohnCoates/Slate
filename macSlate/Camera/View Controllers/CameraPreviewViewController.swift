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

    lazy var contentView: PreviewContentView = PreviewContentView()
    lazy var renderer: Renderer = self.contentView.renderer
    lazy var hudController: HUDController = HUDController(renderer: self.renderer)
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hudController.showWindow(nil)
    }
}
