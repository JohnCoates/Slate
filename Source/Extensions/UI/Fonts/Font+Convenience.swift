//
//  Font+Convenience.swift
//  Flexapp
//
//  Created by John Coates on 8/11/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit

internal enum FontWeight {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black
    
    var rawValue: CGFloat {
        switch self {
        case .ultraLight:
            return UIFontWeightUltraLight
        case .thin:
            return UIFontWeightThin
        case .light:
            return UIFontWeightLight
        case .regular:
            return UIFontWeightRegular
        case .medium:
            return UIFontWeightMedium
        case .semibold:
            return UIFontWeightSemibold
        case .bold:
            return UIFontWeightBold
        case .heavy:
            return UIFontWeightHeavy
        case .black:
            return UIFontWeightBlack
        }
    } // rawValue
}

extension UIFont {
    
    /// Returns the system font with specified size, weight
    class func system(_ size: CGFloat, weight: FontWeight) -> UIFont {
        return systemFont(ofSize: size, weight: weight.rawValue)
    }
    
}
