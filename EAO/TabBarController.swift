//
//  TabBarViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = UIColor.tabUnselectedBackgroundColor
        tabBar.tintColor = UIColor.tabWordColor
        tabBar.barTintColor = UIColor.tabBackgroundColor
    }
}
