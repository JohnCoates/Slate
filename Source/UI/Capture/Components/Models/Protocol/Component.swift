//
//  Component.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import RealmSwift

protocol Component: class {
    var frame: CGRect { get set }
    var view: UIView { get }
    
    func createRealmObject() -> Object
    
    static func createInstance() -> Component
    static func createView() -> UIView
}
