//
//  UIScreen+Layout.swift
//  Slate
//
//  Created by John Coates on 5/19/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

extension UIScreen {
    var sizeRotationIndependent: CGSize {
        var size = self.nativeBounds.size
        size.width /= self.nativeScale
        size.height /= self.nativeScale
        return size
    }
    
    class var orientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
}
