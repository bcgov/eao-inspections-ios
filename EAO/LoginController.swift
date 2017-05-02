//
//  LoginController.swift
//  EAO
//
//  Created by Micha Volin on 2017-04-07.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

class LoginController: UIViewController{
	@IBOutlet var usernameField: UITextField!
	@IBOutlet var passwordField: UITextField!
	
	override func viewDidLoad() {
		self.usernameField.animate(newText: "Inspector", characterDelay: 0.25)
		delay(2.5) {
			self.passwordField.animate(newText: "Inspector", characterDelay: 0.25)
		}
	}
}
