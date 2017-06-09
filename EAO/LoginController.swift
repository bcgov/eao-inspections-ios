//
//  LoginController.swift
//  EAO
//
//  Created by Micha Volin on 2017-04-07.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import Parse
//[username: password]
let users: [String : String] = ["justin.carlson":"dstJC836!","rumon.carter":"dstRC836!","mark.lise":"dstML836!","geoff.mcdonald":"dstGM836!","alex.mclean":"dstAM836!","chris.parks":"dstCP836!","lena.smith":"dstLS836!", "emma":"emma","rohit":"rohit","sam":"sam", "0":"0", "catherine.chernoff":"dstCC836!","tammy.dekens":"dstTD836!"]

class LoginController: UIViewController{
	@IBOutlet fileprivate var usernameField: UITextField!
	@IBOutlet fileprivate var passwordField: UITextField!
	@IBOutlet fileprivate var scrollView: UIScrollView!
	@IBOutlet fileprivate var indicator: UIActivityIndicatorView!
	
	@IBAction fileprivate func loginTapped(_ sender: UIButton) {
		sender.isEnabled = false
		guard let username = usernameField.text?.trimWhiteSpace(), !username.isEmpty() else {
			sender.isEnabled = true
			present(controller: Alerts.error)
			return
		}
		guard let password = passwordField.text?.trimWhiteSpace(), !password.isEmpty() else {
			sender.isEnabled = true
			present(controller: Alerts.error)
			return
		}
//		if !isValid(username: username, password: password){
//			sender.isEnabled = true
//			present(controller: Alerts.error)
//			return
//		}
		self.usernameField.text = ""
		self.passwordField.text = ""
		indicator.startAnimating()
		PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
			guard error == nil else{
				self.present(controller: UIAlertController(title: "Error", message: "Couldn't log in"))
				sender.isEnabled = true
				self.indicator.stopAnimating()
				return
			}

			let query = PFInspection.query()
			query?.whereKey("userId", equalTo: PFUser.current()!.objectId!)
			query?.findObjectsInBackground(block: { (objects, error) in
				objects?.forEach({ (inspection) in
					try? inspection.pin()
				})
				self.indicator.stopAnimating()
				let inspectionsController = InspectionsController.storyboardInstance()
				self.present(controller: inspectionsController)
				sender.isEnabled = true
			})
		}
	}

	@IBAction fileprivate func forgotPasswordTapped(_ sender: UIButton) {
		present(controller: UIAlertController(title: "This feature is coming soon", message: nil))
	}

	@IBAction fileprivate func signupTapped(_ sender: UIButton) {
		present(controller: UIAlertController(title: "This feature is coming soon", message: nil))
	}
	
	override func viewDidLoad() {
		addDismissKeyboardOnTapRecognizer(on: scrollView)
		perform(#selector(presentMainScreen), with: nil, afterDelay: 0)
	}

	func presentMainScreen(){
		if PFUser.current() != nil{
			self.usernameField.text = ""
			self.passwordField.text = ""
			let inspectionsController = InspectionsController.storyboardInstance()
			self.present(controller: inspectionsController)
		}
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

