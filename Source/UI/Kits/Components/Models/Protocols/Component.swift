//
//  Component.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import CoreData

protocol Component: class {
    init()
    
    /// Title used for editing panel
    var editTitle: String { get }
    var frame: CGRect { get set }
    var view: UIView { get }
    
    static func createInstance() -> Component
    static func createView() -> UIView
    
    // Core Data
    
    var coreDataID: NSManagedObjectID? { get set }
    var dbObject: ComponentCoreData? { get set }
    
    func databaseObject(withMutableContext context: NSManagedObjectContext) -> ComponentCoreData
    func configureWithStandardProperties(databaseObject: ComponentCoreData)
}

protocol ComponentDelegate: class {
    func modified(component: Component)
}

// MARK: - Core Data

extension Component {
    
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
