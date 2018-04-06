//
//  CaptureComponent.swift
//  Slate
//
//  Created by John Coates on 5/20/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import CoreData

private typealias LocalClass = CaptureComponent
private typealias LocalView = CaptureButton
final class CaptureComponent: Component, GenericComponent,
EditRounding, EditSize, EditPosition, EditOpacity, EditSmartLayout {
    typealias CoreDataInstance = CaptureComponentCoreData
    typealias ViewInstance = CaptureButton
    
    var coreDataID: NSManagedObjectID?
    weak var typedDBObject: CaptureComponentCoreData?
    
    var editTitle = "Capture"
    
    var frame: CGRect = .zero {
        didSet {
            view.frame = frame
        }
    }
    var smartPin: SmartPin?
    
    lazy var typedView: ViewInstance = LocalClass.createTypedView()
    
    static let defaultRounding: Float = 0.5
    static let defaultOpacity: Float = 0.56
    
    required init() {
    }
}

// MARK: - Core Data

@objc(CaptureComponentCoreData)
class CaptureComponentCoreData: ComponentCoreData, EditRounding, EditOpacity {
    
    @NSManaged public var opacity: Float
    @NSManaged public var rounding: Float
    
    static let defaultRounding: Float = LocalClass.defaultRounding
    static let defaultOpacity: Float = LocalClass.defaultOpacity
    
    override class func modelEntity(version: DataModel.Version, graph: DataModelGraph) -> DBEntity {
        let entity = super.modelEntity(version: version, graph: graph)
        
        return entity
    }
    
    override class var componentNewInstance: Component { return CaptureComponent() }
}

extension CaptureComponent {
    
    func databaseObject(withMutableContext context: NSManagedObjectContext) -> ComponentCoreData {
        return typedDatabaseObject(withMutableContext: context)
    }
    
}
