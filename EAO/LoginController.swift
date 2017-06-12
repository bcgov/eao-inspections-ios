//
//  LoginController.swift
//  EAO
//
//  Created by Micha Volin on 2017-04-07.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import Parse
import Alamofire
final class LoginController: UIViewController{
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
		indicator.startAnimating()
		PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
			self.usernameField.text = ""
			self.passwordField.text = ""
			guard error == nil else{
				self.present(controller: UIAlertController(title: "Error", message: "Couldn't log in"))
				sender.isEnabled = true
				self.indicator.stopAnimating()
				return
			}
			PFInspection.loadAndPin {
				self.load(completion: {
					self.indicator.stopAnimating()
					let inspectionsController = InspectionsController.storyboardInstance()
					self.present(controller: inspectionsController)
					sender.isEnabled = true
				})
			}
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

	fileprivate func load(completion: @escaping ()->()){
		Alamofire.request("https://projects.eao.gov.bc.ca/api/projects/published").responseJSON { response in
			guard let objects = response.result.value as? [Any] else{
				completion()
				return
			}
			var projects = [String?]()
			for case let object as [String: Any] in objects  {
				guard let title = object["name"] as? String else { continue }
				projects.append(title)
			}
			let array = NSArray(array: projects.flatMap({$0}))
			array.write(to: FileManager.directory.appendingPathComponent("projects"), atomically: true)
			completion()
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
	struct Alerts {
		static let error = UIAlertController(title: "Oops...", message: "Could not log in with these credentials")
	}
}



