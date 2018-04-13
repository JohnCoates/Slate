//
//  PreviewContentView.swift
//  Slate
//
//  Created by John Coates on 6/2/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Cocoa
import MetalKit

class PreviewContentView: NSView {
    
    // MARK: - Init
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    lazy var renderer: Renderer = Renderer(kit: Kit(), metalView: self.metalView)!
    let metalView = MTKView()
    
    private func initialSetup() {
        autoresizingMask = [.width, .height]
        metalView.autoresizingMask = [.width, .height]
        metalView.frame = bounds
        addSubview(metalView)
    }
    
}
