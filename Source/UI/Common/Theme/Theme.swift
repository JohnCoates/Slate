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
    
    static func setAppearanceOptions() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = Theme.navigationBarTintColor
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.system(17, weight: .regular)
        ]
        navigationBar.isTranslucent = false
        navigationBar.barStyle = .black
        
        // hide the 1px line at the bottom of the nav bar
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // hide back button text
        let navigationBarButton = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        navigationBarButton.setTitleTextAttributes([
            NSFontAttributeName: UIFont.systemFont(ofSize: 0.1),
            NSForegroundColorAttributeName: UIColor.clear
            ],
                                                   for: UIControlState())
    }
    
    static let navigationBarTintColor = Settings.background
    
    struct Settings {
        static let background = UIColor(red: 0.11, green: 0.12,
                                        blue: 0.15, alpha: 1.00)
    }
    
    struct Kits {
        static let background = UIColor(red: 0.11, green: 0.12,
                                        blue: 0.15, alpha: 1.00)
        static let cellBackground = UIColor(red: 0.12, green: 0.13,
                                            blue: 0.17, alpha: 1.00)
        static let seperatorColor = UIColor(red: 0.20, green: 0.22,
                                            blue: 0.27, alpha: 1.00)
        static let text = UIColor.white
        static let dateText = UIColor(red: 0.59, green: 0.64,
                                      blue: 0.71, alpha: 1.00)
        static let cellTitle: UIFont = {
            return UIFont.system(14, weight: .medium)
        }()
        static let cellSubtitle: UIFont = {
            return UIFont.system(11, weight: .regular)
        }()
        
        static let iconRounding: Float = 0.4
    }
}
