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
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    let mainWindow: NSWindow = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1280 / 2, height: 720 / 2),
                                        styleMask: [.titled, .closable, .miniaturizable,
                                                    .resizable],
                                        backing: .buffered, defer: true)
    lazy var viewController: NSViewController = {
        let viewController = CameraPreviewViewController(nibName: nil, bundle: nil)
        return viewController
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        testRuntimeShaderBuild()
        
        mainWindow.delegate = self
        mainWindow.identifier = NSUserInterfaceItemIdentifier("previewWindow")
        mainWindow.isRestorable = true
        mainWindow.isMovableByWindowBackground = true
        mainWindow.center()
        mainWindow.setFrameAutosaveName(NSWindow.FrameAutosaveName("previewWindow"))
        mainWindow.title = "Preview"
        mainWindow.contentView = viewController.view
        mainWindow.makeKeyAndOrderFront(nil)
        mainWindow.collectionBehavior = [.fullScreenNone]
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    // MARK: - Window Delegate
    
    func windowWillUseStandardFrame(_ window: NSWindow, defaultFrame newFrame: NSRect) -> NSRect {
        var rect = NSRect(x: 0, y: 0, width: 1280 / 1.5, height: 720 / 1.5)
        rect.origin.x = window.frame.minX
        rect.origin.y = window.frame.maxY - rect.height
        return rect
    }

}
