//
//  CameraPositionComponent.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import RealmSwift

class CameraPositionComponent: Component {
    enum Position: Int {
        case front = 0
        case back = 1
    }
    
    var position: Position = .front
    var frame: CGRect = .zero
    var view: UIView = FrontBackCameraToggle()
    
    static func createInstance() -> Component {
        return CameraPositionComponent()
    }
    
    static func createView() -> UIView {
        return FrontBackCameraToggle()
    }
    
    func createRealmObject() -> Object {
        let object = CameraPositionComponentRealm()
        object.frame = self.frame
        object.rawPosition = self.position.rawValue
        return object
    }
}

// MARK: - Realm Object
// https://github.com/realm/realm-cocoa/issues/1109

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

class CameraPositionComponentRealm: ComponentRealm {
    dynamic var rawPosition: Int = CameraPositionComponent.Position.front.rawValue
    
    override func instance() -> Component {
        let instance = CameraPositionComponent()
        instance.frame = frame
        if let position = CameraPositionComponent.Position(rawValue: rawPosition) {
            instance.position = position
        }
        
        return instance
    }
}
