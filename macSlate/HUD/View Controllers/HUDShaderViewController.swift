//
//  HUDShaderViewController.swift
//  Slate
//
//  Created by John Coates on 9/30/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import AppKit

class HUDShaderViewController: NSViewController, NSTextViewDelegate {
    
    // MARK: - Init
    
    weak var renderer: Renderer!
    convenience init(renderer: Renderer) {
        self.init()
        self.renderer = renderer
    }
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 600, height: 300))
        interfaceSetup()
    }
    
    // MARK: - Setup
    
    func interfaceSetup() {
        shaderFieldSetup()
    }
    
    lazy var shaderScrollview = NSScrollView()
    lazy var shaderField = NSTextView()
    
    func shaderFieldSetup() {
        view.addSubview(shaderScrollview)
        
        if let shaderContents = contentsOfShader() {
            let attributedString = NSAttributedString(string: shaderContents)
            shaderField.textStorage?.insert(attributedString, at: 0)
        }
        let frame = NSRect(x: 25, y: 25, width: 550, height: 275)
        shaderScrollview.frame = frame
        shaderScrollview.borderType = .noBorder
        shaderScrollview.hasVerticalScroller = true
        shaderScrollview.autoresizingMask = [.width, .height]
        shaderScrollview.contentView.addSubview(shaderField)
        
        let contentSize = shaderScrollview.contentSize
        shaderField.frame = NSRect(origin: CGPoint(x: 0, y: 0),
                                   size: contentSize)
        
        shaderField.minSize = NSSize(width: 0, height: contentSize.height)
        shaderField.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude,
                                     height: CGFloat.greatestFiniteMagnitude)
        shaderField.isVerticallyResizable = true
        shaderField.isHorizontallyResizable = false
        shaderField.autoresizingMask = .width
        shaderField.textContainer?.containerSize = NSSize(width: contentSize.width,
                                                          height: CGFloat.greatestFiniteMagnitude)
        shaderField.textContainer?.widthTracksTextView = true
        
        shaderScrollview.documentView = shaderField
    }
    
    func contentsOfShader() -> String? {
        let bundle = Bundle.main
        guard
            let shaderPath = bundle.path(forResource: "HUDShader", ofType: "metal")
            else {
            print("Couldn't find HUDShader")
            return nil
        }
        do {
            let contents = try String(contentsOfFile: shaderPath)
            return contents
        } catch {
            print("Error reading shader: \(error)")
        }
        
        return nil
    }
    
    // MARK: - Text Field Delegate
    
    func compileShader() {
        let source = shaderField.string
        let options = MTLCompileOptions()
        
        do {
            let library = try renderer.device.makeLibrary(source: source,
                                                          options: options)
            let functionNames = library.functionNames
            if functionNames.count > 1 {
                print("error, missing function from shader: \(source)")
                return
            } else if functionNames.count == 0 {
                print("error, multiple functions in shader: \(functionNames)")
                return
            }
            let shaderFunction = functionNames[0]
            renderer.updateShader(withLibrary: library,
                                  shaderFunction: shaderFunction)
            
        } catch {
            print("error: \(error)")
        }
    }
    
    @objc(compileShader:)
    func compileShader(event: NSEvent) {
        print("compiling shader!")
        compileShader()
    }
    
}
