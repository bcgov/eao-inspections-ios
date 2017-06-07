//
//  SettingsViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import Parse

class SettingsController: UITableViewController {
	@IBOutlet var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func logoutTapped(_ sender: UIButton) {
		sender.isEnabled = false
		indicator.startAnimating()
		PFUser.logOutInBackground { (error) in
			guard error == nil else{
				sender.isEnabled = true
				self.indicator.stopAnimating()
				self.present(controller: UIAlertController(title: "Error", message: "Couldn't log out, please try again later"))
				return
			}
			self.dismiss(animated: true, completion: nil)
		}
	}
	
}
