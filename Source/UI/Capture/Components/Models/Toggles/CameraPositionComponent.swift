//
//  CameraPositionComponent.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import RealmSwift

class CameraPositionComponent: Component, EditRounding, EditSize {
    enum Position: Int {
        case front = 0
        case back = 1
    }
    
    var position: Position = .front
    var internalFrame: CGRect = .zero
    var frame: CGRect {
        get {
            return internalFrame
        }
        set {
            internalFrame = newValue
            let center = view.center
            view.frame = newValue
            view.center = center
        }
    }
    var size: Float {
        get {
            return Float(frame.size.width)
        }
        set {
            var frame = self.frame
            frame.size.width = CGFloat(newValue)
            frame.size.height = CGFloat(newValue)
            self.frame = frame
        }
    }
    var internalView = FrontBackCameraToggle()
    var view: UIView { return internalView }
    var rounding: Float = 1 {
        didSet {
            internalView.roundingPercentage = rounding
        }
    }
    
    static func createInstance() -> Component {
        return CameraPositionComponent()
    }
    
    static func createView() -> UIView {
        return FrontBackCameraToggle()
    }
    
    func createRealmObject() -> ComponentRealm {
        let object = CameraPositionComponentRealm()
        object.frame = self.frame
        object.rawPosition = self.position.rawValue
        return object
    }
}

// MARK: - Realm Object

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
