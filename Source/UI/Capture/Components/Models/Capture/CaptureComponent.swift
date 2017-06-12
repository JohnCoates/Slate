//
//  CaptureComponent.swift
//  Slate
//
//  Created by John Coates on 5/20/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import RealmSwift
import CoreData

fileprivate typealias LocalClass = CaptureComponent
fileprivate typealias LocalView = CaptureButton
class CaptureComponent: Component, EditRounding, EditSize, EditPosition, EditOpacity {
    var editTitle = "Capture"
    
    var frame: CGRect = .zero {
        didSet {
            view.frame = frame
        }
    }

    var maximumSize: Float = 300
    private lazy var typedView = LocalClass.createTypedView()
    var view: UIView { return typedView }
    
    static let defaultRounding: Float = 0.5
    var rounding: Float = LocalClass.defaultRounding {
        didSet {
            typedView.rounding = rounding
        }
    }
    
    static let defaultOpacity: Float = 0.56
    var opacity: Float = LocalClass.defaultOpacity {
        didSet {
            typedView.opacity = CGFloat(opacity)
        }
    }
    
    required init() {
    }
    
    private static func createTypedView() -> LocalView {
        let view = LocalView()
        view.alpha = CGFloat(defaultOpacity)
        view.rounding = defaultRounding
        return view
    }
    
    static func createView() -> UIView {
        return createTypedView()
    }
    
    func createRealmObject() -> ComponentRealm {
        let object = RealmObject()
        configureWithStandardProperties(realmObject: object)
        return object
    }
    
}

// MARK: - Realm Object

fileprivate typealias RealmObject = CaptureComponentRealm
class CaptureComponentRealm: ComponentRealm, EditRounding, EditOpacity {
    
    dynamic var rounding: Float = LocalClass.defaultRounding
    dynamic var opacity: Float = LocalClass.defaultOpacity
    
    override func instance() -> Component {
        let instance = LocalClass()
        configureWithStandardProperies(instance: instance)
        
        return instance
    }
    
}

// MARK: - Core Data

@objc(CaptureComponentCoreData)
class CaptureComponentCoreData: ComponentCoreData {
    
    @NSManaged public var opacity: Float
    @NSManaged public var rounding: Float
    
    override class func constructModelEntity() -> DBEntity {
        let entity = super.constructModelEntity()
        
        entity.addAttribute(name: "opacity", type: .float,
                            defaultValue: 1)
        entity.addAttribute(name: "rounding", type: .float,
                            defaultValue: 0)
        
        return entity
    }
    
}
