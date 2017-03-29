//
//  AppDelegate.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
		LaunchScreen.show()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
		
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
		
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
		LaunchScreen.hide()
    }

    func applicationWillTerminate(_ application: UIApplication) {
		
    }


}

