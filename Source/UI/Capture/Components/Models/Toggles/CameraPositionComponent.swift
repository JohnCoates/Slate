//
//  CameraPositionComponent.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import RealmSwift
import CoreData

fileprivate typealias LocalClass = CameraPositionComponent
fileprivate typealias LocalView = FrontBackCameraToggle
class CameraPositionComponent: Component,
EditRounding, EditOpacity, EditSize, EditPosition, KeepUpright {
    
    var coreDataID: NSManagedObjectID?
    
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
    static let defaultRounding: Float = 1
    var rounding: Float = LocalClass.defaultRounding {
        didSet {
            typedView.rounding = rounding
        }
    }
    
    static let defaultOpacity: Float = 1
    var opacity: Float = LocalClass.defaultOpacity {
        didSet {
            typedView.opacity = opacity
        }
    }
    
    required init() {
    }
    
    private static func createTypedView() -> LocalView {
        let view = LocalView()
        view.opacity = defaultOpacity
        view.rounding = defaultRounding
        return view
    }
    
    static func createView() -> UIView {
        return createTypedView()
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

// MARK: - Core Data

@objc(CameraPositionComponentCoreData)
class CameraPositionComponentCoreData: ComponentCoreData, EditRounding, EditOpacity {
    
    @NSManaged public var opacity: Float
    @NSManaged public var rounding: Float
    
    override class func constructModelEntity() -> DBEntity {
        let entity = super.constructModelEntity()
        
        entity.addAttribute(name: "opacity", type: .float,
                            defaultValue: LocalClass.defaultOpacity)
        entity.addAttribute(name: "rounding", type: .float,
                            defaultValue: LocalClass.defaultRounding)
        
        return entity
    }
    
    override class var componentNewInstance: Component { return CameraPositionComponent() }
}

extension CameraPositionComponent: ComponentDatabase {
    
    func newDatabaseObject(in context: NSManagedObjectContext) -> CameraPositionComponentCoreData {
        let dbObject: CameraPositionComponentCoreData = context.insertObject()
        return dbObject
    }
    
    func databaseObject(in context: NSManagedObjectContext) -> ComponentCoreData {
        let object: CameraPositionComponentCoreData
        
        if let coreDataID = coreDataID {
            object = context.object(fromID: coreDataID)
        } else {
            object = newDatabaseObject(in: context)
        }
        
        configureWithStandardProperties(databaseObject: object)
        return object
    }
    
}
