//
//  CameraPositionComponent.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import RealmSwift

class CameraPositionComponent: Component,
EditRounding, EditSize, EditPosition {
    enum Position: Int {
        case front = 0
        case back = 1
    }
    
    var parentKit: Kit?
    
    var position: Position = .front
    var internalFrame: CGRect = .zero
    var frame: CGRect {
        get {
            return internalFrame
        }
        set {
            internalFrame = newValue
//            let center = view.center
            view.frame = newValue
//            view.center = center
        }
    }
    var origin: CGPoint {
        get {
            return internalFrame.origin
        }
        set {
            frame.origin = newValue
            internalFrame.origin = newValue
        }
    }
    var size: Float {
        get {
            return Float(frame.size.width)
        }
        set {
            var frame = self.frame
            let difference: CGFloat
            difference = CGFloat(newValue) - frame.size.width
            frame.origin.x -= (difference / 2)
            frame.origin.y -= (difference / 2)
            
            frame.size.width = CGFloat(newValue)
            frame.size.height = CGFloat(newValue)
            self.frame = frame
        }
    }
    var maximumSize: Float = 300
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
        object.frame = frame
        object.rawPosition = position.rawValue
        object.rounding = rounding
        return object
    }
}

// MARK: - Realm Object

fileprivate typealias RealmObject = CameraPositionComponentRealm
class CameraPositionComponentRealm: ComponentRealm {
    dynamic var rawPosition: Int = CameraPositionComponent.Position.front.rawValue
    
    static let defaultRounding: Float = 1
    dynamic var rounding: Float = RealmObject.defaultRounding
    
    override func instance() -> Component {
        let instance = CameraPositionComponent()
        instance.frame = frame
        instance.rounding = rounding
        if let position = CameraPositionComponent.Position(rawValue: rawPosition) {
            instance.position = position
        }
        
        return instance
    }
}
