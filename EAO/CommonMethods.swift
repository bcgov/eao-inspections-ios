//
//  CommonMethods.swift
//  EAO
//
//  Created by Work on 2017-02-21.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

class CommonMethods: NSObject {}

//MARK: - ViewController present and dismiss
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
    
    class func showStoryBoard(storyBoard: String){
        
        let appdel = UIApplication.shared.delegate as! AppDelegate
        let storyBoardS = UIStoryboard(name:storyBoard, bundle: nil).instantiateInitialViewController()!
        let root = appdel.window?.rootViewController
        storyBoardS.modalTransitionStyle = .coverVertical
        root?.present(storyBoardS, animated: false, completion: nil)
        
    }
    
    class func hideViewController(viewController: CommonViewController){
        
        viewController.dismiss(animated: true, completion: nil)
        
    }
    
}

