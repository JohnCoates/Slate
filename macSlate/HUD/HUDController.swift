//
//  HUDController.swift
//  Slate
//
//  Created by John Coates on 9/29/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import AppKit

class HUDController: NSWindowController {
    var contentController: NSViewController!
    
    convenience init(renderer: Renderer) {
        let contentController = HUDTextureViewController(renderer: renderer)
        let window = NSPanel(contentViewController: contentController)
        window.styleMask = [window.styleMask, .utilityWindow, .hudWindow]
        window.title = "Metal Settings"
        window.isFloatingPanel = false
        window.hidesOnDeactivate = false
        window.titleVisibility = .visible
        window.hasShadow = true
        window.isRestorable = true
        window.identifier = NSUserInterfaceItemIdentifier("metalHUD")
        
        self.init(window: window)
        self.shouldCascadeWindows = false
        window.setFrameAutosaveName(NSWindow.FrameAutosaveName("metalHUD"))
        window.setFrameUsingName(NSWindow.FrameAutosaveName("metalHUD"))
        
        self.contentController = contentController
    }
    
}
