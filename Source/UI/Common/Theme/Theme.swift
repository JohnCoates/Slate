//
//  Theme.swift
//  Slate
//
//  Created by John Coates on 6/4/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable nesting

import UIKit

class Theme {
    struct Kits {
        static let background = UIColor(red: 0.11, green: 0.12, blue: 0.15, alpha: 1.00)
        static let text = UIColor.white
        static let dateText = UIColor(red: 0.59, green: 0.64, blue: 0.71, alpha: 1.00)
        static let cellTitle: UIFont = {
            return UIFont.system(14, weight: .medium)
        }()
        static let cellSubtitle: UIFont = {
            return UIFont.system(11, weight: .regular)
        }()
        
        static let iconRounding: Float = 0.4
    }
}
