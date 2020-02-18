//
//  AppDelegate.swift
//  Creative
//
//  Created by Bali on 12/6/14.
//  Copyright (c) 2014 kil-dev. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup UI tint colors.
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = KColors.tint
        navigationBarAppearace.barTintColor = KColors.barTint
        // Change navigation item title color.
        navigationBarAppearace.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: KColors.tint]

        NetworkActivityIndicatorManager.shared.startDelay = 0.0
        NetworkActivityIndicatorManager.shared.isEnabled = true

        return true
    }
}
