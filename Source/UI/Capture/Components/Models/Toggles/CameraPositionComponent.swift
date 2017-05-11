//
//  CameraPositionComponent.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

class CameraPositionComponent: Component {
    enum Position {
        case front
        case back
    }
    
    var position: Position = .front
    var frame: CGRect = .zero
    var view: UIView = FrontBackCameraToggle()
    
    static func createInstance() -> Component {
        return CameraPositionComponent()
    }
    
    static func createView() -> UIView {
        return FrontBackCameraToggle()
    }
    
}
