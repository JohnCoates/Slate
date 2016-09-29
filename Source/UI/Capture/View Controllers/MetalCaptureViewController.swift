//
//  MetalCaptureViewController.swift
//  Slate
//
//  Created by John Coates on 9/27/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit
import MetalKit

final class MetalCaptureViewController: UIViewController {
    
    var renderer: Renderer!
    
    override func loadView() {
        let metalView = MTKView()
        view = metalView
        
        renderer = Renderer(metalView: metalView)
    }
}
