//
//  Component.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import RealmSwift
import CoreData

protocol Component: class {
    init()
    
    /// Title used for editing panel
    var editTitle: String { get }
    var frame: CGRect { get set }
    var view: UIView { get }
    
    func createRealmObject() -> ComponentRealm
    func configureWithStandardProperties(realmObject: ComponentRealm)
    
    static func createInstance() -> Component
    static func createView() -> UIView
}

protocol ComponentDatabase: class {
    var coreDataID: NSManagedObjectID? { get set }
    
    func databaseObject(in context: NSManagedObjectContext) -> ComponentCoreData
    func configureWithStandardProperties(databaseObject: ComponentCoreData)
}

protocol ComponentDelegate: class {
    func modified(component: Component)
}

// MARK: - Defaults

extension Component {
    
    static func createInstance() -> Component {
        return self.init()
    }
    
    func configureWithStandardProperties(realmObject: ComponentRealm) {
        if let component = self as? EditRounding,
            let realm = realmObject as? EditRounding {
            realm.rounding = component.rounding
        }
        
        if let component = self as? EditOpacity,
            let realm = realmObject as? EditOpacity {
            realm.opacity = component.opacity
        }
        
        realmObject.frame = self.frame
    }
    
}

// MARK: - Core Data

extension ComponentDatabase where Self: Component {
    
    func configureWithStandardProperties(databaseObject: ComponentCoreData) {
        if let component = self as? EditRounding,
            let dbObject = databaseObject as? EditRounding {
            dbObject.rounding = component.rounding
        }
        
        if let component = self as? EditOpacity,
            let dbObject = databaseObject as? EditOpacity {
            dbObject.opacity = component.opacity
        
        }
        databaseObject.frame = DBRect(rect: frame)
    }
    
}
