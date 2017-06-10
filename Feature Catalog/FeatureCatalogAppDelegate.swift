//
//  AppDelegate.swift
//  Feature Catalog
//
//  Created by John Coates on 5/13/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setUpWindow()
        return true
    }
    
    func setUpWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        let catalogController = FeatureCatalogViewController()
        let navigationController = UINavigationController(rootViewController: catalogController)
        window.rootViewController = navigationController
        self.window = window
    }
    
}
