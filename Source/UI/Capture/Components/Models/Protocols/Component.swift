//
//  Component.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import RealmSwift

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
