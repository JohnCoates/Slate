//
//  AppDelegate.swift
//  macSlate
//
//  Created by John Coates on 9/29/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Cocoa
import MetalKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var renderer: Renderer!
    
    var hudController: HUDController!
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let view = MTKView()
        window.contentView = view
        
        renderer = Renderer(metalView: view)
        
        hudController = HUDController(renderer: renderer)
        hudController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}
