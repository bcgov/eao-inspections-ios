//
//  LoginController.swift
//  EAO
//
//  Created by Micha Volin on 2017-04-07.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

//[username: password]
let users: [String : String] = ["justin.carlson":"dstJC836!","rumon.carter":"dstRC836!","mark.lise":"dstML836!","geoff.mcdonald":"dstGM836!","alex.mclean":"dstAM836!","chris.parks":"dstCP836!","lena.smith":"dstLS836!", "emma":"emma","rohit":"rohit","sam":"sam", "0":"0", "catherine.chernoff":"dstCC836!","tammy.dekens":"dstTD836!"]

class LoginController: UIViewController{
	@IBOutlet var usernameField: UITextField!
	@IBOutlet var passwordField: UITextField!
	@IBOutlet var scrollView: UIScrollView!
	
	@IBAction func loginTapped(_ sender: UIButton) {
		sender.isEnabled = false
//		guard let username = usernameField.text, !username.isEmpty() else {
//			sender.isEnabled = true
//			present(controller: Alerts.error)
//			return
//		}
//		guard let password = passwordField.text, !password.isEmpty() else {
//			sender.isEnabled = true
//			present(controller: Alerts.error)
//			return
//		}
//		if !isValid(username: username, password: password){
//			sender.isEnabled = true
//			present(controller: Alerts.error)
//			return
//		}
		currentUsername = usernameField.text 
		usernameField.text = ""
		passwordField.text = ""
		let inspectionsController = InspectionsController.storyboardInstance()
		present(controller: inspectionsController)
		sender.isEnabled = true
	}
	
	override func viewDidLoad() {
		addDismissKeyboardOnTapRecognizer(on: scrollView)
		
	}
}

extension LoginController: UITextFieldDelegate{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		dismissKeyboard()
		return true
	}
}

extension LoginController{
	func isValid(username: String, password: String) -> Bool{
		return users[username.lowercased()] == password
	}
}

extension LoginController{
	struct Alerts {
		static let error = UIAlertController(title: "Oops...", message: "Could not log in with these credentials")
	}
}

