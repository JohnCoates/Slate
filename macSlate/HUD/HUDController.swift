//
//  HUDController.swift
//  Slate
//
//  Created by John Coates on 9/29/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import AppKit
import Cartography

class HUDController: NSWindowController {
    var contentController: HUDContentController!
    
    convenience init(renderer: Renderer) {
        let contentController = HUDContentController(renderer: renderer)
        let window = NSPanel(contentViewController: contentController)
        window.styleMask = [window.styleMask, .utilityWindow, .hudWindow]
        window.title = "Metal Settings"
        window.isFloatingPanel = false
        window.hidesOnDeactivate = false
        window.titleVisibility = .visible
        window.hasShadow = true
        
        self.init(window: window)
        
        self.contentController = contentController
    }
    
}

class HUDContentController: NSViewController, NSTextFieldDelegate {
    
    weak var renderer: Renderer!
    convenience init(renderer: Renderer) {
        self.init()
        self.renderer = renderer
    }
    
    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y:0, width: 600, height: 300))
        interfaceSetup()
    }
    
    func interfaceSetup() {
        vertexFieldsSetup()
    }

    var vertexFields = [NSTextField]()
    
    func vertexFieldsSetup() {
        var previousField: NSTextField?
        let count = renderer.vertices.count
        for index in 0..<count {
            previousField = createVertexField(index: index,
                                              previousField: previousField)
        }
    }
    
    func createVertexField(index: Int,
                           previousField: NSTextField?) -> NSTextField {
        let field = NSTextField()
        let textureCoordinates = renderer.textureCoordinates[index]
        let x = textureCoordinates.x
        let y = textureCoordinates.y
        field.stringValue = "\(x),\(y)"
        field.formatter = TexturePairFormatter()
        field.delegate = self
        vertexFields.append(field)
        view.addSubview(field)
        
        constrain(field) {
            let superview = $0.superview!
            $0.width == 60
            $0.height == 24
            
            if previousField == nil {
                $0.top == superview.top + 10
            }
        }
        
        let label = NSTextField(labelWithString: "vertex \(index)")
        label.textColor = NSColor.white
        view.addSubview(label)
        constrain(label, field) { label, field in
            let superview = label.superview!
            label.left == superview.left + 10
            field.left >= label.right + 10 ~ LayoutPriority(1000)
            label.top == field.top
        }
        
        if let previousField = previousField {
            constrain(field, previousField) { field, previousField in
                field.left == previousField.left
                field.top == previousField.bottom + 10
            }
        }
        
        return field
    }
    
    @objc func control(_ control: NSControl,
                        textShouldEndEditing fieldEditor: NSText) -> Bool {
        guard
            let field = control as? NSTextField,
            let index = vertexFields.index(of: field) else {
            fatalError("invalid field")
        }
        
        let string = field.stringValue
        update(vertexIndex: index, withText: string)
        return true
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        guard let field = obj.object as? NSTextField,
        let index = vertexFields.index(of: field)
            else {
            fatalError("invalid field")
        }
        let string = field.stringValue
        update(vertexIndex: index, withText: string)
    }
    
    func update(vertexIndex index: Int, withText string: String) {
        print("update \(index): \(string)")
        let scanner = Scanner(string: string)
        
        var x: Float = 0
        var y: Float = 0
        guard
            scanner.scanFloat(&x),
            scanner.scanString(",", into: nil),
            scanner.scanFloat(&y) else {
                print("Couldn't read texture coordinates from: \(string), vertex: \(index)")
                return
        }
        
        renderer.textureCoordinates[index].x = x
        renderer.textureCoordinates[index].y = y
        renderer.invalidateTextureCoordinatesBuffer()
    }
}

class TexturePairFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        if obj == nil {
            return nil
        }
        guard let string = obj as? String else {
            fatalError("Invalid object: \(obj)")
        }
        
        return string
    }
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                 for string: String,
                                 errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string as NSString
        return true
    }
    override func isPartialStringValid(_ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>,
                                       proposedSelectedRange proposedSelRangePtr: NSRangePointer?,
                                       originalString origString: String,
                                       originalSelectedRange origSelRange: NSRange,
                                       errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let string = partialStringPtr.pointee
        
        if string.length == 0 {
            return true
        }
        
        let scanner = Scanner(string: string as String)
        
        if !scanner.scanFloat(nil) {
            NSBeep()
            return false
        }
        if !scanner.scanString(",", into: nil) {
            NSBeep()
            return false
        }
        
        if !scanner.scanFloat(nil) {
            NSBeep()
            return false
        }
        
        if !scanner.isAtEnd {
            NSBeep()
            return false
        }
        
        return true
    }
}
