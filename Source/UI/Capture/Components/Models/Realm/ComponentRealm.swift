//
//  ComponentRealm.swift
//  Slate
//
//  Created by John Coates on 5/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

// https://github.com/realm/realm-cocoa/issues/1109

import UIKit
import RealmSwift

// MARK: - Base Class

class ComponentRealm: Object {
    var frame: CGRect {
        get {
            return CGRect(x: originX, y: originY, width: width, height: height)
        }
        set (frame) {
            originX = frame.origin.x
            originY = frame.origin.y
            width = frame.size.width
            height = frame.size.height
        }
    }
    
    dynamic var originX: CGFloat = 0.0
    dynamic var originY: CGFloat = 0.0
    dynamic var width: CGFloat = 0.0
    dynamic var height: CGFloat = 0.0
    
    override class func ignoredProperties() -> [String] {
        return ["frame"]
    }
    
    func instance() -> Component {
        fatalError("instance() has not been implemented")
    }
}

// MARK: - Union Class

class ComponentUnionRealm: Object {
    dynamic var kind: Int = -1
    
    enum Kind: Int {
        case cameraPosition = 0
        case capture = 1
    }
    
    dynamic var cameraPosition: CameraPositionComponentRealm?
    dynamic var capture: CaptureComponentRealm?
    
    func configure(withComponent component: Component) {
        if let cameraPosition = component as? CameraPositionComponent {
            configure(withCameraPosition: cameraPosition)
        } else if let capture = component as? CaptureComponent {
            configure(withCapture: capture)
        } else {
            fatalError("Missing component case for: \(component)")
        }
    }
    
    func configure(withCameraPosition cameraPosition: CameraPositionComponent) {
        kind = Kind.cameraPosition.rawValue
        self.cameraPosition = cameraPosition.createRealmObject() as? CameraPositionComponentRealm
    }
    
    func configure(withCapture capture: CaptureComponent) {
        kind = Kind.capture.rawValue
        self.capture = capture.createRealmObject() as? CaptureComponentRealm
    }
    
    func instance() -> Component {
        guard let kind = Kind(rawValue: self.kind) else {
            fatalError("Unsupported kind: \(self.kind)")
        }
        
        switch kind {
        case .cameraPosition:
            guard let typed = self.cameraPosition else {
                fatalError("Missing cameraPosition variable")
            }
            return typed.instance()
        case .capture:
            guard let typed = self.capture else {
                fatalError("Missing capture variable")
            }
            return typed.instance()
        }
    }
}
