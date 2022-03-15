//
//  AppDelegate.swift
//  MyTimerApp
//
//  Created by Gustavo Tellez on 15/03/22.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigation: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        self.navigation = nil
        self.navigation = UINavigationController()
        self.navigation?.viewControllers.removeAll()
        
        let view = MyTimerView()
        
        self.navigation?.pushViewController(view, animated: false)
        self.navigation?.popToRootViewController(animated: false)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController  = nil
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        return true
    }
}

