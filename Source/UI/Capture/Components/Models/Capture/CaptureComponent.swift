//
//  CaptureComponent.swift
//  Slate
//
//  Created by John Coates on 5/20/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import RealmSwift

fileprivate typealias LocalClass = CaptureComponent
fileprivate typealias LocalView = CaptureButton
class CaptureComponent: Component, EditRounding, EditSize, EditPosition {
    var editTitle = "Capture"
    
    var frame: CGRect = .zero {
        didSet {
            view.frame = frame
        }
    }

    var maximumSize: Float = 300
    var typedView = CaptureButton()
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
        return object
    }
}

// MARK: - Realm Object

fileprivate typealias RealmObject = CaptureComponentRealm
class CaptureComponentRealm: ComponentRealm, EditRounding {
    
    dynamic var rounding: Float = LocalClass.defaultRounding
    
    override func instance() -> Component {
        let instance = LocalClass()
        instance.frame = frame
        instance.rounding = rounding
        
        return instance
    }
}
