//
//  InspectionSetupController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

final class InspectionSetupController: UIViewController, KeyboardDelegate{
	public var inspection: PFInspection?
	fileprivate var inputs = [String : Any?]()
	
	//MARK: -
	
	@IBOutlet var button	 : UIButton!
	@IBOutlet var indicator  : UIActivityIndicatorView!
	@IBOutlet var scrollView : UIScrollView!
	//[Title, subtitle, subtext]
	@IBOutlet var fields  : [UITextField]!
	//[selectProject, start date, end date]
	@IBOutlet var buttons : [UIButton]!
 
	@IBAction func projectTapped(_ sender: UIButton) {
		let projectListController = ProjectListController.storyboardInstance() as! ProjectListController
		projectListController.result = { (title) in
			guard let title = title else { return }
			sender.setTitle(title, for: .normal)
			self.inputs["project"] = title
		}
		push(controller: projectListController)
	}
	
	//sender: tag 10 is start date button, tag 11 is end date button
	@IBAction func pickDate(_ sender: UIButton) {
		DatePickerController.present(on: self, minimum: inputs["start"] as? Date) { [weak self] (date) in
			guard let date = date else { return }
			sender.setTitle(date.datePickerFormat(), for: .normal)
			self?.inputs[sender.tag == 10 ? "start" : "end"] = date
		}
	}
	
	@IBAction func createTapped(_ sender: UIButton) {
		sender.isEnabled = false
		if isReadOnly{
			let inspectionFormController = InspectionFormController.storyboardInstance() as! InspectionFormController
			inspectionFormController.inspection = inspection
			self.push(controller: inspectionFormController)
			sender.isEnabled = true
			return
		}
		indicator.startAnimating()
		validate { (inspection, isNew) in
			guard let inspection = inspection else {
				sender.isEnabled = true
				self.indicator.stopAnimating()
				return
			}
			inspection.isSubmitted = false 
			inspection.pinInBackground(block: { (success, error) in
				guard success, error == nil else{
					self.indicator.stopAnimating()
					sender.isEnabled = true
					self.present(controller: UIAlertController(title: "ERROR!", message: "Inspection failed to be saved.\nError Description: \(error?.localizedDescription ?? "nil")"))
					return
				}
				if isNew{
					InspectionsController.reference?.prepend(inspection: inspection)
				} else{
					InspectionsController.reference?.tableView.reloadData()
				}
				let inspectionFormController = InspectionFormController.storyboardInstance() as! InspectionFormController
				inspectionFormController.inspection = inspection
				self.push(controller: inspectionFormController)
				sender.setTitle("Modify", for: .normal)
				sender.isEnabled = true
				self.indicator.stopAnimating()
			})
		}
	}
	
	//MARK: -
	override func viewDidLoad() {
		addDismissKeyboardOnTapRecognizer(on: scrollView)
		populate()
		if isReadOnly{
			buttons.forEach({ (button) in
				button.isEnabled = false
			})
			fields.forEach({ (field) in
				field.isEnabled = false
			})
			button.setTitle("Next", for: .normal)
		} else if inspection == nil{
			button.setTitle("Create", for: .normal)
		} else{
			button.setTitle("Modify", for: .normal)
		}
	}
 
	deinit {
		print("deinit set up inspection")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		addKeyboardObservers()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		removeKeyboardObservers()
	}
	
	//MARK: -
	func keyboardWillShow(with height: NSNumber) {
		scrollView.contentInset.bottom = CGFloat(height)
	}
	
	func keyboardWillHide() {
		scrollView.contentInset.bottom = 0
	}
	
	//MARK: -
	func populate(){
		guard let inspection = inspection else { return }
		buttons[0].setTitle(inspection.project, for: .normal)
		buttons[1].setTitle(inspection.start?.datePickerFormat(), for: .normal)
		buttons[2].setTitle(inspection.end?.datePickerFormat(), for: .normal)
		
		fields[0].text = inspection.title
		fields[1].text = inspection.subtitle
		fields[2].text = inspection.subtext
		fields[3].text = inspection.number
		
		inputs["title"] = inspection.title
		inputs["subtitle"] = inspection.subtitle
		inputs["subtext"] = inspection.subtext
		inputs["number"] = inspection.number
		inputs["project"] = inspection.project
		inputs["start"] = inspection.start
		inputs["end"] = inspection.end
	}
}

extension InspectionSetupController: UITextFieldDelegate{
	func textFieldDidEndEditing(_ textField: UITextField) {
		var text = textField.text
		if text?.isEmpty() == true{
			text = nil
		}
		switch textField{
		case fields[0]:
			inputs["title"] = text
		case fields[1]:
			inputs["subtitle"] = text
		case fields[2]:
			inputs["subtext"] = text
		case fields[3]:
			inputs["number"] = text
		default:
			return
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let i = fields.index(of: textField){
			if i == 3{
				dismissKeyboard()
				return true
			}
			fields[i+1].becomeFirstResponder()
		}
		return true
	}
}

extension InspectionSetupController{
	func validate(completion: @escaping (_ inspection : PFInspection?, _ isNew: Bool)->Void){
		let inputs = self.inputs.flatMap({$0})
		if inputs.count < 7{
			present(controller: Alerts.fields)
			completion(nil, false)
			return
		}
		if !validateDates() {
			present(controller: Alerts.dates)
			completion(nil, false)
			return
		}
		var isNew = false
		if inspection == nil {
			isNew = true
			inspection = PFInspection()
		}
		for (key,input) in inputs{
			inspection?.setValue(input, forKey: key)
		}
		completion(inspection,isNew)
	}
	
	func validateDates() -> Bool{
		guard let startDate = inputs["start"] as? Date,  
			let endDate = inputs["end"] as? Date else {
			return false
		}
		return startDate < endDate
	}
}

extension InspectionSetupController{
	fileprivate var isReadOnly: Bool{
		return inspection?.isSubmitted?.boolValue == true
	}
}

extension InspectionSetupController{
	struct Alerts{
		static let fields = UIAlertController(title: "Incomplete", message: "Please fill out all fields")
		static let dates = UIAlertController(title: "Dates", message: "Please make sure end date goes after start date")
		static let error = UIAlertController(title: "ERROR!", message: "Inspection failed to be saved,\nPlease try again")
	}
}









