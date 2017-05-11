//
//  Component.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

protocol Component {
    var frame: CGRect { get set }
    var view: UIView { get }
    
    static func createInstance() -> Component
    static func createView() -> UIView
}
