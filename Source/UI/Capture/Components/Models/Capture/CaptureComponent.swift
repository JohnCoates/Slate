//
//  CaptureComponent.swift
//  Slate
//
//  Created by John Coates on 5/20/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import CoreData

fileprivate typealias LocalClass = CaptureComponent
fileprivate typealias LocalView = CaptureButton
class CaptureComponent: Component,
EditRounding, EditSize, EditPosition, EditOpacity {
    
    var coreDataID: NSManagedObjectID?
    weak var dbObject: ComponentCoreData?
    
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
    
}

// MARK: - Core Data

@objc(CaptureComponentCoreData)
class CaptureComponentCoreData: ComponentCoreData, EditRounding, EditOpacity {
    
    @NSManaged public var opacity: Float
    @NSManaged public var rounding: Float
    
    static let defaultRounding: Float = LocalClass.defaultRounding
    static let defaultOpacity: Float = LocalClass.defaultOpacity
    
    override class func constructModelEntity() -> DBEntity {
        let entity = super.constructModelEntity()
        
        return entity
    }
    
    override class var componentNewInstance: Component { return CaptureComponent() }
}

extension CaptureComponent: ComponentDatabase {
    
    func newDatabaseObject(in context: NSManagedObjectContext) -> CaptureComponentCoreData {
        let dbObject: CaptureComponentCoreData = context.insertObject()
        self.dbObject = dbObject
        return dbObject
    }
    
    func databaseObject(in context: NSManagedObjectContext) -> ComponentCoreData {
        let object: CaptureComponentCoreData
        
        if let dbObject = dbObject as? CaptureComponentCoreData {
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
