//
//  SettingsViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
	override var shouldAutorotate: Bool{
		return false
	}

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func logoutTapped(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
}
