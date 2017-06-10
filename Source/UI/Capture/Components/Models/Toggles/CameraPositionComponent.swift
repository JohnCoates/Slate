//
//  CameraPositionComponent.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import RealmSwift

fileprivate typealias LocalClass = CameraPositionComponent
fileprivate typealias LocalView = FrontBackCameraToggle
class CameraPositionComponent: Component,
EditRounding, EditSize, EditPosition, KeepUpright {
    var editTitle = "Switch Camera"
    
    enum Position: Int {
        case front = 0
        case back = 1
    }
    
    var position: Position = .front
    var frame: CGRect = .zero {
        didSet {
            view.frame = frame
        }
    }
    
    var maximumSize: Float = 300
    var typedView = FrontBackCameraToggle()
    var view: UIView { return typedView }
    static let defaultRounding: Float = 0.5
    var rounding: Float = LocalClass.defaultRounding {
        didSet {
            typedView.rounding = rounding
        }
    }
    
    required init() {
    }
    
    static func createView() -> UIView {
        return LocalView()
    }
    
    func createRealmObject() -> ComponentRealm {
        let object = RealmObject()
        configureWithStandardProperties(realmObject: object)
        object.rawPosition = position.rawValue
        return object
    }
    
}

// MARK: - Realm Object

fileprivate typealias RealmObject = CameraPositionComponentRealm
class CameraPositionComponentRealm: ComponentRealm, EditRounding {
    dynamic var rawPosition: Int = CameraPositionComponent.Position.front.rawValue
    
    dynamic var rounding: Float = LocalClass.defaultRounding
    
    override func instance() -> Component {
        let instance = LocalClass()
        configureWithStandardProperies(instance: instance)
        if let position = CameraPositionComponent.Position(rawValue: rawPosition) {
            instance.position = position
        } else {
            fatalError("couldn't cast position: \(rawPosition) to enum")
        }
        
        return instance
    }
    
}
