//
//  CanvasIcon.swift
//  Slate
//
//  Created by John Coates on 5/16/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// Canvases imported from PaintCode

import UIKit

protocol CanvasIcon {
    var width: CGFloat { get }
    var height: CGFloat { get}
    func draw(toTargetFrame targetFrame: CGRect, contentMode: CanvasIconContentMode)
    func drawing()
}

extension CanvasIcon {
    func draw(toTargetFrame targetFrame: CGRect, contentMode: CanvasIconContentMode) {
        let context = contextSetUp(targetFrame: targetFrame, contentMode: contentMode)
        drawing()
        tearDown(context: context)
    }
    
    func contextSetUp(targetFrame: CGRect, contentMode: CanvasIconContentMode) -> CGContext {
        guard let context = UIGraphicsGetCurrentContext() else {
            fatalError("Couldn't get current graphics context!")
        }
        context.saveGState()
        
        let canvasFrame = CGRect(x: 0, y: 0, width: width, height: height)
        let resizedFrame: CGRect = contentMode.apply(rect: canvasFrame, target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / width, y: resizedFrame.height / height)
        return context
    }
    
    func tearDown(context: CGContext) {
        context.restoreGState()
    }
}


enum CanvasIconContentMode: Int {
    case aspectFit /// The content is proportionally resized to fit into the target rectangle.
    case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
    case stretch /// The content is stretched to match the entire target rectangle.
    case center /// The content is centered in the target rectangle, but it is NOT resized.
    
    static func from(contentMode: UIViewContentMode) -> CanvasIconContentMode {
        switch contentMode {
        case .scaleAspectFit:
            return .aspectFit
        case .scaleAspectFill:
            return .aspectFill
        case .scaleToFill:
            return .stretch
        case .center:
            return .center
        default:
            return .aspectFit
        }
    }
    
    public func apply(rect: CGRect, target: CGRect) -> CGRect {
        if rect == target || target == CGRect.zero {
            return rect
        }
        
        var scales = CGSize.zero
        scales.width = abs(target.width / rect.width)
        scales.height = abs(target.height / rect.height)
        
        switch self {
        case .aspectFit:
            scales.width = min(scales.width, scales.height)
            scales.height = scales.width
        case .aspectFill:
            scales.width = max(scales.width, scales.height)
            scales.height = scales.width
        case .stretch:
            break
        case .center:
            scales.width = 1
            scales.height = 1
        }
        
        var result = rect.standardized
        result.size.width *= scales.width
        result.size.height *= scales.height
        result.origin.x = target.minX + (target.width - result.width) / 2
        result.origin.y = target.minY + (target.height - result.height) / 2
        return result
    }
}
