//
//  InspectionSetupController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

class InspectionSetupController: UIViewController{
	
	@IBOutlet var scrollView: UIScrollView!
	
 
	@IBAction func projectTapped(_ sender: UIButton) {
		let projectListController = ProjectListController.storyboardInstance() as! ProjectListController
		projectListController.result = { (title) in
			(self.view.viewWithTag(1) as! UIButton).setTitle(title, for: .normal)
		}
		push(controller: projectListController)
	}
	
	@IBAction func startDateTapped(_ sender: UIButton) {
		
	}
	
	@IBAction func endDateTapped(_ sender: UIButton) {
		
	}
	
	@IBAction func createTapped(_ sender: UIButton) {
		let inspectionFormController = InspectionFormController.storyboardInstance() as! InspectionFormController
		push(controller: inspectionFormController)
	}
	
	override func viewDidLoad() {
		scrollView.contentInset.bottom = 200
		scrollView.contentInset.top = 10
		
		addDismissKeyboardOnTapRecognizer(on: scrollView)
	}
	
}
