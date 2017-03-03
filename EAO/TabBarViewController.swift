//
//  TabBarViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = .lightGray  //set to appropriate color
        tabBar.tintColor = .black  //set to appropriate color
        tabBar.barTintColor = .white  //set to appropriate color
    }
}
