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
            return UIFont.Weight.ultraLight.rawValue
        case .thin:
            return UIFont.Weight.thin.rawValue
        case .light:
            return UIFont.Weight.light.rawValue
        case .regular:
            return UIFont.Weight.regular.rawValue
        case .medium:
            return UIFont.Weight.medium.rawValue
        case .semibold:
            return UIFont.Weight.semibold.rawValue
        case .bold:
            return UIFont.Weight.bold.rawValue
        case .heavy:
            return UIFont.Weight.heavy.rawValue
        case .black:
            return UIFont.Weight.black.rawValue
        }
    } // rawValue
}

extension UIFont {
    
    /// Returns the system font with specified size, weight
    class func system(_ size: CGFloat, weight: FontWeight) -> UIFont {
        return systemFont(ofSize: size, weight: UIFont.Weight(rawValue: weight.rawValue))
    }
    
}
