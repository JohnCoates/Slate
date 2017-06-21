//
//  LayoutScale.swift
//  Slate
//
//  Created by John Coates on 6/19/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class LayoutScale {
    
    // MARK: - Init
    
    let size: Size
    let nativeSize: Size
    
    init(size: Size, nativeSize: Size) {
        self.size = size
        self.nativeSize = nativeSize
    }
    
    // MARK: - Scaling
    
    lazy var ratio: Size = {
        return Size(width: self.size.width / self.nativeSize.width,
                    height: self.size.height / self.nativeSize.height)
    }()
    
    lazy var isNative: Bool = {
        if self.ratio.width == 1, self.ratio.height == 1 {
            return true
        } else {
            return false
        }
    }()
    
    func convert(x: CGFloat) -> CGFloat {
        return x * ratio.cgWidth
    }
    
    func convert(y: CGFloat) -> CGFloat {
        return y * ratio.cgHeight
    }
    
    func convert(size: CGSize) -> CGSize {
        return CGSize(width: size.width * ratio.cgWidth,
                      height: size.height * ratio.cgHeight)
    }
    
    func convert(rect: CGRect) -> CGRect {
        return CGRect(x: rect.origin.x * ratio.cgWidth,
                      y: rect.origin.y * ratio.cgHeight,
                      width: rect.size.width * ratio.cgWidth,
                      height: rect.size.height * ratio.cgHeight)
    }
    
}
