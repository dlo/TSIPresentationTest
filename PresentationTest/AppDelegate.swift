//
//  AppDelegate.swift
//  PresentationTest
//
//  Created by Daniel Loewenherz on 1/31/17.
//  Copyright © 2017 Lionheart Software LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let _window = UIWindow(frame: UIScreen.main.bounds)
        _window.makeKeyAndVisible()
        _window.rootViewController = ImageViewController()

        window = _window

        return true
    }
}

