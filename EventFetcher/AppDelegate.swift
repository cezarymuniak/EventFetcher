//
//  AppDelegate.swift
//  EventFetcher
//
//  Created by Cezary Muniak on 21/05/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainViewController = MainViewController()
        
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

