//
//  AppDelegate.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 1.0)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground //UIColor(named: CustomColor.background.rawValue) // .black //
        let root = TabbarViewController()
        window?.rootViewController = root
        window?.makeKeyAndVisible()
        
        return true
    }

}

