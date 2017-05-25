//
//  InspectionSetupController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

final class InspectionSetupController: UIViewController, KeyboardDelegate{
	var inspection: PFInspection?
	fileprivate var isNew = false
	fileprivate var inputs = [String : Any?]()
	//MARK: - IB Outlets
	@IBOutlet fileprivate var button	 : UIButton!
	@IBOutlet fileprivate var indicator  : UIActivityIndicatorView!
	@IBOutlet fileprivate var scrollView : UIScrollView!
	//[Title, subtitle, subtext]
	@IBOutlet fileprivate var fields  : [UITextField]!
	//[selectProject, start date, end date]
	@IBOutlet fileprivate var buttons : [UIButton]!
 
	//MARK: - IB Actions
	@IBAction fileprivate func projectTapped(_ sender: UIButton) {
		let projectListController = ProjectListController.storyboardInstance() as! ProjectListController
		projectListController.result = { (title) in
			guard let title = title else { return }
			sender.setTitle(title, for: .normal)
			self.inputs["project"] = title
		}
		push(controller: projectListController)
	}
	
	//sender: tag 10 is start date button, tag 11 is end date button
	@IBAction fileprivate func pickDate(_ sender: UIButton) {
		DatePickerController.present(on: self, minimum: inputs["start"] as? Date) { [weak self] (date) in
			guard let date = date else { return }
			self?.navigationItem.rightBarButtonItem?.isEnabled = true
			sender.setTitle(date.datePickerFormat(), for: .normal)
			self?.inputs[sender.tag == 10 ? "start" : "end"] = date
		}
	}
	
	@IBAction fileprivate func saveTapped(_ sender: UIBarButtonItem?=nil) {
		sender?.isEnabled = false
		indicator.startAnimating()
		validate { (inspection) in
			guard let inspection = inspection else {
				sender?.isEnabled = true
				self.indicator.stopAnimating()
				return
			}
			inspection.isSubmitted = false
			inspection.pinInBackground(block: { (success, error) in
				guard success, error == nil else{
					self.indicator.stopAnimating()
					sender?.isEnabled = true
					self.present(controller: UIAlertController(title: "ERROR!", message: "Inspection failed to be saved.\nError Description: \(error?.localizedDescription ?? "nil")"))
					return
				}
				if self.isNew{
					InspectionsController.reference?.prepend(inspection: inspection)
				} else{
					InspectionsController.reference?.tableView.reloadData()
				}
				if self.isNew{
					self.isNew = false
					let inspectionFormController = InspectionFormController.storyboardInstance() as! InspectionFormController
					inspectionFormController.inspection = inspection
					self.push(controller: inspectionFormController)
					self.setMode()
				}
				self.indicator.stopAnimating()
				self.showSuccessImageView()
			})
		}
	}
	
	@IBAction fileprivate func addElementTapped(_ sender: UIButton) {
		sender.isEnabled = false
		if isNew{
			saveTapped()
			sender.isEnabled = true
			return
		}
		let inspectionFormController = InspectionFormController.storyboardInstance() as! InspectionFormController
		inspectionFormController.inspection = inspection
		self.push(controller: inspectionFormController)
		sender.isEnabled = true
	}
	
	//MARK: -
	override func viewDidLoad() {
		addDismissKeyboardOnTapRecognizer(on: scrollView)
		if inspection == nil{
			isNew = true
		}
		setMode()
		populate()
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
	
	fileprivate func setMode(){
		if isReadOnly{
			buttons.forEach({ (button) in
				button.isEnabled = false
			})
			fields.forEach({ (field) in
				field.isEnabled = false
			})
			setNavigationRightItemAsEye()
		} else if isNew{
			//new
			button.setTitle("Create Inspection", for: .normal)
			navigationItem.rightBarButtonItem = nil
		} else{
			//modifying
			button.setTitle("Add Elements", for: .normal)
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped(_:)))
			navigationItem.rightBarButtonItem?.isEnabled = false
		}
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

	//MARK: -
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
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		navigationItem.rightBarButtonItem?.isEnabled = true
		return true
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

//MARK: -
extension InspectionSetupController{
	func validate(completion: @escaping (_ inspection : PFInspection?)->Void){
		let inputs = self.inputs.flatMap({$0})
		if inputs.count < 7{
			present(controller: Alerts.fields)
			completion(nil)
			return
		}
		if !validateDates() {
			present(controller: Alerts.dates)
			completion(nil)
			return
		}
		if self.isNew {
			inspection = PFInspection()
		}
		for (key,input) in inputs{
			inspection?.setValue(input, forKey: key)
		}
		completion(inspection)
	}
	
	func validateDates() -> Bool{
		guard let startDate = inputs["start"] as? Date,  
			let endDate = inputs["end"] as? Date else {
			return false
		}
		return startDate < endDate
	}
}

//MARK: -
extension InspectionSetupController{
	fileprivate var isReadOnly: Bool{
		return inspection?.isSubmitted?.boolValue == true
	}
}

//MARK: -
extension InspectionSetupController{
	struct Alerts{
		static let fields = UIAlertController(title: "Incomplete", message: "Please fill out all fields")
		static let dates = UIAlertController(title: "Dates", message: "Please make sure end date goes after start date")
		static let error = UIAlertController(title: "ERROR!", message: "Inspection failed to be saved,\nPlease try again")
	}
}

