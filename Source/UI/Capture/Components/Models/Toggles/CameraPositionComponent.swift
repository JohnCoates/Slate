//
//  CameraPositionComponent.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import CoreData

fileprivate typealias LocalClass = CameraPositionComponent
class CameraPositionComponent: Component,
EditRounding, EditOpacity, EditSize, EditPosition, KeepUpright {
    
    typealias AssociatedView = FrontBackCameraToggle
    
    var coreDataID: NSManagedObjectID?
    
    var editTitle = "Switch Camera"
    
    enum Position: Int {
        case front = 0
        case back = 1
    }
    
    static let defaultCameraPosition: Position = .front
    var cameraPosition: Position = LocalClass.defaultCameraPosition
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
    
    private static func createTypedView() -> AssociatedView {
        let view = AssociatedView()
        view.opacity = defaultOpacity
        view.rounding = defaultRounding
        return view
    }
    
    static func createView() -> UIView {
        return createTypedView()
    }
    
}

// MARK: - Core Data

@objc(CameraPositionComponentCoreData)
class CameraPositionComponentCoreData: ComponentCoreData, EditRounding, EditOpacity {
    
    @NSManaged public var opacity: Float
    @NSManaged public var rounding: Float
    @NSManaged public var cameraPosition: Int
    
    static var defaultRounding: Float = LocalClass.defaultRounding
    static var defaultOpacity: Float = LocalClass.defaultOpacity
    
    override class func constructModelEntity() -> DBEntity {
        let entity = super.constructModelEntity()
        
        entity.addAttribute(name: "cameraPosition", type: .int16,
                            defaultValue: LocalClass.defaultCameraPosition.rawValue)
        
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
