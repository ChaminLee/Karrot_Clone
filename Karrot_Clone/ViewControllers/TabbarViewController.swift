//
//  TabbarViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/15.
//

import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {

    var home: HomeViewController!
    var town: LifeViewController!
    var around: AroundViewController!
    var chat: ChatViewController!
    var my: MyViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBars()
    }
    
    func setupTabBars() {
        // home
        let homeview = UINavigationController(rootViewController: HomeViewController())
        let homeitem = UITabBarItem(title: "홈" ,image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        homeview.navigationController?.navigationBar.isTranslucent = false
        homeview.navigationController?.navigationController?.navigationBar.backgroundColor = UIColor.green //UIColor(named: CustomColor.background.rawValue)
        homeview.tabBarItem = homeitem
        
        
        // Town
        let lifeview = UINavigationController(rootViewController: LifeViewController())
        let lifeitem = UITabBarItem(title: "동네생활", image: UIImage(systemName: "newspaper"), selectedImage: UIImage(systemName: "newspaper.fill",withConfiguration: UIImage.SymbolConfiguration(weight: .bold)))

        
        lifeview.tabBarItem = lifeitem
        
        // Around
        let aroundview =  UINavigationController(rootViewController: AroundViewController())
        let arounditem = UITabBarItem(title: "내 근처", image: UIImage(systemName: "globe"), selectedImage: UIImage(systemName: "globe", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)))

        aroundview.tabBarItem = arounditem
                
        // Chat
        let chatview = UINavigationController(rootViewController: ChatViewController())
        let chatitem = UITabBarItem(title: "채팅", image: UIImage(systemName: "bubble.left.and.bubble.right"), selectedImage: UIImage(systemName: "bubble.left.and.bubble.right.fill"))

        chatview.tabBarItem = chatitem
        
        // My
        let myview = UINavigationController(rootViewController: MyViewController())
        let myitem = UITabBarItem(title: "나의 당근" , image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        myview.tabBarItem = myitem
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(named: CustomColor.background.rawValue)
        UITabBar.appearance().tintColor = UIColor(named: CustomColor.text.rawValue)
        
        self.viewControllers = [homeview, lifeview, aroundview, chatview, myview]
        
    }
   
    // [ ] 탭바 아이템 클릭시 최상단 이동
}



