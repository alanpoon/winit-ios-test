//
//  AppDelegate.swift
//  winit-ios
//
//  Created by Joep Kneefel on 16/07/2023.
//

// import UIKit

// @main
// class MyApp {
//     static func main() {
//         start_app();
//     }
// }

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Call your custom function when the app becomes active
         start_app()
    }
}