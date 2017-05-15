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
    var frame: CGRect { get set }
    var view: UIView { get }
    var parentKit: Kit? { get set }
    
    func createRealmObject() -> ComponentRealm
    
    static func createInstance() -> Component
    static func createView() -> UIView
}

protocol ComponentDelegate: class {
    func modified(component: Component)
}
