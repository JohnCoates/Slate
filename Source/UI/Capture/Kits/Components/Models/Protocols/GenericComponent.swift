//
//  GenericComponent.swift
//  Slate
//
//  Created by John Coates on 6/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import CoreData

protocol GenericComponent: Component {
    associatedtype CoreDataInstance: ComponentCoreData
    associatedtype ViewInstance: UIView
    
    var typedDBObject: CoreDataInstance? { get set }
    var typedView: ViewInstance { get set }
    
    static func createTypedView() -> ViewInstance
    
    // Optionals
    func configureWithSpecializedProperties(databaseObject: CoreDataInstance)
    func configureWithSpecializedProperties(view: ViewInstance)
}

extension GenericComponent {
    
    func typedDatabaseObject(withMutableContext context: NSManagedObjectContext) -> CoreDataInstance {
        let object: CoreDataInstance
        
        if let dbObject = typedDBObject {
            object = dbObject
        } else if let coreDataID = coreDataID {
            object = context.object(fromID: coreDataID)
            typedDBObject = object
        } else {
            object = context.insertObject()
            typedDBObject = object
        }
        
        configureWithStandardProperties(databaseObject: object)
        configureWithSpecializedProperties(databaseObject: object)
        
        return object
    }
    
    static func createTypedView() -> ViewInstance {
        let view = ViewInstance.init()
        
        if let parameter = self as? EditOpacity.Type,
            let parameterView = view as? EditOpacity {
            parameterView.opacity = parameter.defaultOpacity
        }
        
        if let parameter = self as? EditRounding.Type,
            let parameterView = view as? EditRounding {
            parameterView.rounding = parameter.defaultRounding
        }
        
        return view
    }
    
    // MARK: - Optionals
    
    func configureWithSpecializedProperties(databaseObject: CoreDataInstance) {}
    
    func configureWithSpecializedProperties(view: ViewInstance) {}
    
    // MARK: - Component
    
    static func createInstance() -> Component {
        return self.init()
    }
    
    static func createView() -> UIView {
        return createTypedView()
    }
    
    var view: UIView {
        get {
            return typedView
        }
        
        set {
            guard let typedValue = newValue as? ViewInstance else {
                fatalError("Incorrect view type set: \(newValue)")
            }
            
            typedView = typedValue
        }
    }
    
    var dbObject: ComponentCoreData? {
        get {
            return typedDBObject
        }
        set {
            guard let typedValue = newValue as? CoreDataInstance else {
                fatalError("Incorrect dbObject set: \(String(describing: newValue))")
            }
            
            typedDBObject = typedValue
        }
    }
    
}
