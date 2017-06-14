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
class SwitchCameraComponent: Component, GenericComponent,
EditRounding, EditOpacity, EditSize, EditPosition, KeepUpright {
    typealias CoreDataInstance = CameraPositionComponentCoreData
    typealias ViewInstance = SwitchCameraButton
    
    var coreDataID: NSManagedObjectID?
    var typedDBObject: CoreDataInstance?
    
    var editTitle = "Switch Camera"
    
    var frame: CGRect = .zero {
        didSet {
            view.frame = frame
        }
    }
    
    lazy var typedView = LocalClass.createTypedView()
    
    required init() {
    }
}

// MARK: - Core Data

extension SwitchCameraComponent {
    
    func databaseObject(withMutableContext context: NSManagedObjectContext) -> ComponentCoreData {
        return typedDatabaseObject(withMutableContext: context)
    }
    
}

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
