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
        start_app()
        return true
    }
}