//
//  HUDTextureViewController.swift
//  Slate
//
//  Created by John Coates on 9/30/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import AppKit

class HUDTextureViewController: NSViewController, NSTextFieldDelegate {
    
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
        field.formatter = FloatPairFormatter()
        field.delegate = self
        vertexFields.append(field)
        view.addSubview(field)
        
        field.width --> 60
        field.height --> 24
        
        if previousField == nil {
            field.top.pin(to: view.top, add: 10)
        }
        
        let label = NSTextField(labelWithString: "vertex \(index)")
        label.textColor = NSColor.white
        view.addSubview(label)
        
        label.left.pin(to: view.left, add: 10)
        field.left.pin(atLeast: label.right, add: 10)
        label.top --> field.top
        
        if let previousField = previousField {
            field.left --> previousField.left
            field.top.pin(to: previousField.bottom, add: 10)
        }
        
        return field
    }
    
    // MARK: - Text Field Delegate
    
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
    
    // MARK: - Vertex Updating
    
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
