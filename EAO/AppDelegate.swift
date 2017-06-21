//
//  AppDelegate.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import Fabric
import Crashlytics
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var shouldRotate = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		if ProcessInfo.processInfo.arguments.contains("UITests") {
			UIView.setAnimationsEnabled(false)
			window?.layer.speed = 500
		}
		Fabric.with([Crashlytics.self])
		 
		Parse.initialize(with: configuration)
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.blue
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        return true
    }

	func application(_ application: UIApplication,supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return shouldRotate ? .allButUpsideDown : .portrait
	}
}

extension AppDelegate{
	static var reference: AppDelegate?{
		return UIApplication.shared.delegate as? AppDelegate
	}
	static var root: UIViewController?{
		return AppDelegate.reference?.window?.rootViewController
	}
}





