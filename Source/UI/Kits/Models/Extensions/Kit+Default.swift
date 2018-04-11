//
//  Kit+Default.swift
//  Slate
//
//  Created by John Coates on 6/19/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

extension Kit {
    
    static func `default`() -> Kit {
//        let kit = Kit()
//        kit.configureDefaultKit()
        return KitManager.currentKit
    }
    
    func configureDefaultKit() {
        nativeSize = Size(width: 640, height: 1136)
        
        let captureComponent = CaptureComponent()
        captureComponent.frame = CGRect(x: 245, y: 946, width: 150, height: 150)
        
        captureComponent.rounding = 1
        addComponent(component: captureComponent)
        
        let switchComponent = SwitchCameraComponent()
        switchComponent.frame = CGRect(x: 537, y: 15, width: 88, height: 88)
        addComponent(component: switchComponent)
    }
    
    func configureWithSmartPin(captureComponent: CaptureComponent) {
        captureComponent.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        captureComponent.smartPin = SmartPin(nativeX: .center(offset: 0),
                                             nativeY: .max(offset: 0),
                                             foreignX: .center(offset: 0),
                                             foreignY: .max(offset: -40))
    }
    
}
