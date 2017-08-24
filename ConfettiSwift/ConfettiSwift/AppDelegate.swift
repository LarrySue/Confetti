//
//  AppDelegate.swift
//  ConfettiSwift
//
//  Created by LarrySue on 2017/8/24.
//  Copyright © 2017年 personal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = HomeViewController()
        let navVc = UINavigationController(rootViewController: vc)
        
        window?.rootViewController = navVc
        window?.makeKeyAndVisible()
        
        return true
    }
}

