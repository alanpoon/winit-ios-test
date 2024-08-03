//
//  AppDelegate.swift
//  winit-ios
//
//  Created by Joep Kneefel on 16/07/2023.
//

import UIKit

//@main
//class MyApp {
//    static func main() {
//        start_app();
//    }
//}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainStroryBoard = UIStoryboard(name: "Storyboard", bundle: nil)
        window?.rootViewController = mainStroryBoard.instantiateInitialViewController()

        window?.makeKeyAndVisible()
        return true
    }

}


