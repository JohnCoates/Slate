//
//  SwitchCameraComponent.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import CoreData

fileprivate typealias LocalClass = SwitchCameraComponent
class SwitchCameraComponent: Component,
EditRounding, EditOpacity, EditSize, EditPosition, KeepUpright {
    
    typealias AssociatedView = SwitchCameraButton
    
    var coreDataID: NSManagedObjectID?
    weak var dbObject: ComponentCoreData?
    
    var editTitle = "Switch Camera"
    
    var frame: CGRect = .zero {
        didSet {
            view.frame = frame
        }
    }
    
    var maximumSize: Float = 300
    var typedView = SwitchCameraButton()
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
    
    static var defaultRounding: Float = LocalClass.defaultRounding
    static var defaultOpacity: Float = LocalClass.defaultOpacity
    
    override class func constructModelEntity() -> DBEntity {
        let entity = super.constructModelEntity()
        
        return entity
    }
    
    override class var componentNewInstance: Component { return SwitchCameraComponent() }
}

extension SwitchCameraComponent {
    
    func newDatabaseObject(in context: NSManagedObjectContext) -> CameraPositionComponentCoreData {
        let dbObject: CameraPositionComponentCoreData = context.insertObject()
        return dbObject
    }
    
    func databaseObject(in context: NSManagedObjectContext) -> ComponentCoreData {
        let object: CameraPositionComponentCoreData
        
        if let dbObject = dbObject as? CameraPositionComponentCoreData {
            object = dbObject
        } else if let coreDataID = coreDataID {
            object = context.object(fromID: coreDataID)
            self.dbObject = object
        } else {
            object = newDatabaseObject(in: context)
            self.dbObject = object
        }
        
        configureWithStandardProperties(databaseObject: object)
        return object
    }
    
}
