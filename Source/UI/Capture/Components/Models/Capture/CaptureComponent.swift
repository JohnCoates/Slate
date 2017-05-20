//
//  CaptureComponent.swift
//  Slate
//
//  Created by John Coates on 5/20/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

fileprivate typealias LocalClass = CaptureComponent
fileprivate typealias LocalView = CaptureButton
class CaptureComponent: Component, EditRounding, EditSize, EditPosition {
    var editTitle = "Capture"
    
    var parentKit: Kit?
    var frame: CGRect = .zero {
        didSet {
            view.frame = frame
        }
    }
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame.origin = newValue
        }
    }
    
    var size: Float {
        get {
            return Float(frame.size.width)
        }
        set {
            var frame = self.frame
            let difference: CGFloat
            difference = CGFloat(newValue) - frame.size.width
            // center
            frame.origin.x -= (difference / 2)
            frame.origin.y -= (difference / 2)
            
            frame.size.width = CGFloat(newValue)
            frame.size.height = CGFloat(newValue)
            self.frame = frame
        }
    }
    var maximumSize: Float = 300
    var typedView = CaptureButton()
    var view: UIView { return typedView }
    var rounding: Float = 0.5 {
        didSet {
            typedView.rounding = rounding
        }
    }
    
    static func createInstance() -> Component {
        return LocalClass()
    }
    
    static func createView() -> UIView {
        return LocalView()
    }
    
    func createRealmObject() -> ComponentRealm {
        let object = RealmObject()
        object.frame = frame
        object.rounding = rounding
        return object
    }
}

// MARK: - Realm Object

fileprivate typealias RealmObject = CaptureComponentRealm
class CaptureComponentRealm: ComponentRealm {
    
    static let defaultRounding: Float = 1
    dynamic var rounding: Float = RealmObject.defaultRounding
    
    override func instance() -> Component {
        let instance = LocalClass()
        instance.frame = frame
        instance.rounding = rounding
        
        return instance
    }
}
