//
//  AppDelegate.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import Fabric
import Crashlytics
import UIKit
import Parse
import Alamofire

public func delay(_ delay:Double, closure:@escaping ()->()) {
	DispatchQueue.main.asyncAfter(
		deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	static let reference = UIApplication.shared.delegate as? AppDelegate
	static let root = AppDelegate.reference?.window?.rootViewController
	
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		if ProcessInfo.processInfo.arguments.contains("UITests") {
			UIView.setAnimationsEnabled(false)
			window?.layer.speed = 100
		}
		Fabric.with([Crashlytics.self])
		let configuration = ParseClientConfiguration {
			$0.applicationId = "XTHCaxK6sIDRsk27KOacQLYy4ZXHlf9XUi6DxSLx"
			$0.clientKey     = "Bq8cEpJRuHW29byxt18yf1MKTmjRvbrEOkIGNCQu"
			$0.server        = "https://parseapi.back4app.com/"
			$0.isLocalDatastoreEnabled = true
		}
		Parse.initialize(with: configuration)
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.blue
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
		
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
		
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
		
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
		
    }

    func applicationWillTerminate(_ application: UIApplication) {
		
    }
}

