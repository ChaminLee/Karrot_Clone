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
    var floatingButtonController: FloatingButtonController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 1.0)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black //UIColor(named: CustomColor.background.rawValue)  //.systemBackground //
        let root = TabbarViewController()
        window?.rootViewController = root
        window?.makeKeyAndVisible()
        
        floatingButtonController = FloatingButtonController()        
//        floatingButtonController?.AddButton.addTarget(self, action: #selector(floatingButtonWasTapped), for: .touchUpInside)
        
        return true
    }
    
    @objc func floatingButtonWasTapped() {
        let alert = UIAlertController(title: "Warning", message: "Don't do that!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Sorry…", style: .default, handler: nil)
        alert.addAction(action)
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

}

