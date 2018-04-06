//
//  SmartPin.swift
//  Slate
//
//  Created by John Coates on 6/19/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class SmartPin {
    
    enum SmartAnchor {
        case min(offset: CGFloat)
        case max(offset: CGFloat)
        case center(offset: CGFloat)
//        case division(base: Int, index: Int, offset: CGFloat)
        var layoutAttributeX: LayoutAttribute {
            switch self {
            case .min:
                return .left
            case .max:
                return .right
            case .center:
                return .centerX
            }
        }
        
        var layoutAttributeY: LayoutAttribute {
            switch self {
            case .min:
                return .top
            case .max:
                return .bottom
            case .center:
                return .centerY
            }
        }
        
        var offset: CGFloat {
            switch self {
            case .min(let offset), .max(let offset), .center(let offset):
                return offset
                
            }
        }
    }
    
    var nativeX: SmartAnchor
    var nativeY: SmartAnchor
    
    var foreignX: SmartAnchor
    var foreignY: SmartAnchor
    
    init(nativeX: SmartAnchor, nativeY: SmartAnchor, foreignX: SmartAnchor, foreignY: SmartAnchor) {
        self.nativeX = nativeX
        self.nativeY = nativeY
        self.foreignX = foreignX
        self.foreignY = foreignY
    }
    
    // MARK: - Applying
    
    @discardableResult
    func apply(nativeView: UIView, foreignView: UIView, scale: LayoutScale) -> [NSLayoutConstraint] {
        let nativeAnchorX = Anchor<XAxis>(target: nativeView,
                                          kind: nativeX.layoutAttributeX)
        
        let nativeAnchorY = Anchor<YAxis>(target: nativeView,
                                          kind: nativeY.layoutAttributeY)
        
        let foreignAnchorX = Anchor<XAxis>(target: foreignView,
                                           kind: foreignX.layoutAttributeX)
        
        let foreignAnchorY = Anchor<YAxis>(target: foreignView,
                                           kind: foreignY.layoutAttributeY)
        
        let offsetX: CGFloat = scale.convert(x: nativeX.offset + foreignX.offset)
        let offsetY: CGFloat = scale.convert(y: nativeY.offset + foreignY.offset)
        
        let xConstraint = nativeAnchorX.pin(to: foreignAnchorX, add: offsetX)
        let yConstraint = nativeAnchorY.pin(to: foreignAnchorY, add: offsetY)
        
        return [xConstraint, yConstraint]
    }
    
}
