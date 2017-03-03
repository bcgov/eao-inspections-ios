//
//  CommonMethods.swift
//  EAO
//
//  Created by Work on 2017-02-21.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

class CommonMethods: NSObject {}

//MARK: -
extension CommonMethods {
    class func showLaunchScreen() {
        let appdel = UIApplication.shared.delegate as! AppDelegate
        let launchscreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()!
        let tabBarController = appdel.window?.rootViewController
        launchscreen.modalTransitionStyle = .crossDissolve
        tabBarController?.present(launchscreen, animated: false, completion: nil)
    }

    class func hideLaunchScreen() {
        let appdel = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = appdel.window?.rootViewController
        tabBarController?.dismiss(animated: true, completion: nil)
    }
}

