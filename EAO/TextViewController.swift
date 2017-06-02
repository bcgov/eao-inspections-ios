//
//  TextViewController.swift
//  EAO
//
//  Created by Micha Volin on 2017-05-28.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

final class TextViewController: UIViewController, KeyboardDelegate{
	var result: ((_ text: String?)->Void)?
	var initialText: String?
	
	@IBOutlet fileprivate var textView: UITextView!
	
	@IBAction fileprivate func doneTapped(_ sender: UIBarButtonItem) {
		result?(textView.text)
		pop()
	}
	
	override func viewDidLoad() {
		textView.text = initialText
		navigationItem.setHidesBackButton(true, animated: false)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		removeKeyboardObservers()
		AppDelegate.reference?.shouldRotate = false
		let value =  UIInterfaceOrientation.portrait.rawValue
		UIDevice.current.setValue(value, forKey: "orientation")
		UIViewController.attemptRotationToDeviceOrientation()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		addKeyboardObservers()
		AppDelegate.reference?.shouldRotate = true
		textView.becomeFirstResponder()
	}
	
	func keyboardWillShow(with height: NSNumber) {
		textView.contentInset.bottom = CGFloat(height.intValue + 60)
	}
}
