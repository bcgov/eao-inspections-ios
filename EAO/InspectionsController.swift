//
//  EAOInspectionsController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import MapKit
import Parse

class InspectionsController: UIViewController, CLLocationManagerDelegate{
	//MARK: Properties
	fileprivate let locationManager = CLLocationManager()
	var isBeingUploaded = false
	var inspections = [Int:[PFInspection]]()
	//MARK: IB Outlets
	@IBOutlet var tableView: UITableView!
	@IBOutlet fileprivate var addNewInspectionButton: UIButton!
	@IBOutlet fileprivate var tableViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet fileprivate var segmentedControl: UISegmentedControl!
	@IBOutlet fileprivate var indicator: UIActivityIndicatorView!
	//MARK: IB Actions
	
	@IBAction func addInspectionTapped(_ sender: UIButton) {
		sender.isEnabled = false
		let inspectionSetupController = InspectionSetupController.storyboardInstance() as! InspectionSetupController
		push(controller: inspectionSetupController)
		sender.isEnabled = true
	}

	@IBAction func editTapped(_ sender: UIButton, forEvent event: UIEvent) {
		guard let indexPath = tableView.indexPath(for: event), let inspection = inspections[0]?[indexPath.row], inspection.id != nil else{
			return
		}
		let inspectionSetupController = InspectionSetupController.storyboardInstance() as! InspectionSetupController
		inspectionSetupController.inspection = inspections[selectedIndex]?[indexPath.row]

		let inspectionFormController = InspectionFormController.storyboardInstance() as! InspectionFormController
		inspectionFormController.inspection = inspections[selectedIndex]?[indexPath.row]

		navigationController?.setViewControllers([self,inspectionSetupController, inspectionFormController], animated: true)

	}

	@IBAction func uploadTapped(_ sender: UIButton, forEvent event: UIEvent) {
		if isBeingUploaded{
			AlertView.present(on: self, with: "Only one inspection can be submitted at a time")
			return
		}
		guard let indexPath = tableView.indexPath(for: event),let inspection = inspections[0]?[indexPath.row] else{
			AlertView.present(on: self, with: "Inspection was not found")
			return
		}
		submit(inspection: inspection, indexPath: indexPath)
	}
	
	@IBAction func segmentedControlChangedValue(_ sender: UISegmentedControl) {
		addNewInspectionButton.isHidden = selectedIndex == 0 ? false : true
		tableViewBottomConstraint.constant = selectedIndex == 0 ? 10 : -60
		view.layoutIfNeeded()
		tableView.reloadData()
		print("index: \(inspections[selectedIndex]?.count)")
	}
	
	//MARK: -
	override func viewDidLoad() {
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		tableView.contentInset.bottom = 10
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		self.load()
	}
	
	func submit(inspection: PFInspection, indexPath: IndexPath){
		let alert = UIAlertController(title: "Are You Sure?", message: "You will NOT be able to edit this inspection after submission", yes: {
			self.indicator.startAnimating()
			self.isBeingUploaded = true
			inspection.isBeingUploaded = true
			self.tableView.reloadData()
			inspection.submit(completion: { (success, error) in
				self.indicator.stopAnimating()
				inspection.isBeingUploaded = false
				self.isBeingUploaded = false
				if let error = error {
					self.present(controller: UIAlertController(title: "Error", message: error.message))
				}
				self.tableView.reloadData()
				print(self.inspections)
				guard success else{
					
					self.tableView.reloadData()
					return
				}
				self.showSuccessImageView()

				self.moveToSubmitted(inspection: inspection)
				
			}, block: { (progress) in
				inspection.progress = progress
				self.tableView.reloadRows(at: [indexPath], with: .none)
			})
		})
		present(controller: alert)
	}
	
	//MARK: -
	func load(){
		indicator.startAnimating()
		let query = PFInspection.query()
		query?.fromLocalDatastore()
		query?.whereKey("userId", equalTo: PFUser.current()!.objectId!)
		query?.order(byDescending: "start")
		query?.findObjectsInBackground(block: { (objects, error) in
			guard let objects = objects as? [PFInspection], error == nil else{
				print("none")
				return
			}
			var inspections = [Int:[PFInspection]]()
			objects.forEach({ (inspection) in
				if let status = inspection.isSubmitted?.intValue{
					if inspections[status] == nil{
						inspections[status] = []
					}
					inspections[status]?.append(inspection)
				}
			})
			self.indicator.stopAnimating()
			self.inspections = inspections
			self.tableView.reloadData()
		})
	}
	
	///Use this method to prepend an inspection to the 'In Progress' tab
	public func prepend(inspection: PFInspection?){
		if let inspection = inspection{
			if self.inspections[0] == nil{
				self.inspections[0] = []
			}
			self.inspections[0]?.insert(inspection, at: 0)
			self.inspections[0]?.sort(by: { (left, right) -> Bool in
				guard let startL = left.start, let startR = right.start else{
					return false
				}
				return startL > startR
			})
			self.tableView.reloadData()
		}
	}
	
	///Use this method to put an inspection from 'In Progress' tp 'Submitted'
	public func moveToSubmitted(inspection: PFInspection?){
		if let inspection = inspection{
			guard let i = inspections[0]?.index(of: inspection) else{
				return
			}
			self.inspections[0]?.remove(at: i)
			if self.inspections[1] == nil{
				self.inspections[1] = []
			}
			self.inspections[1]?.insert(inspection, at: 0)
			self.inspections[1]?.sort(by: { (left, right) -> Bool in
				guard let startL = left.start, let startR = right.start else{
					return false
				}
				return startL > startR
			})
			self.tableView.reloadData()
		}
	}
}

//MARK: -
extension InspectionsController: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("count: \(inspections[selectedIndex]?.count ?? 0)")
		return inspections[selectedIndex]?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeue(identifier: "InspectionsCell") as! InspectionsCell
		let inspection = inspections[selectedIndex]?[indexPath.row]
		print("ins -\(indexPath.row)-: \(inspection)")
		var date = ""
		if let start = inspection?.start, let end = inspection?.end{
			date = "\(start.inspectionFormat()) - \(end.inspectionFormat())"
		}
		cell.setData(title: inspection?.title, time: date, isReadOnly: Bool(NSNumber(integerLiteral: selectedIndex)), progress: inspection?.progress ?? 0, isBeingUploaded: false, isEnabled: self.isBeingUploaded, linkedProject: inspection?.project)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if inspections[selectedIndex]?[indexPath.row].id != nil{
			let inspectionSetupController = InspectionSetupController.storyboardInstance() as! InspectionSetupController
			inspectionSetupController.inspection = inspections[selectedIndex]?[indexPath.row]
			
			let inspectionFormController = InspectionFormController.storyboardInstance() as! InspectionFormController
			inspectionFormController.inspection = inspections[selectedIndex]?[indexPath.row]
			
			navigationController?.setViewControllers([self,inspectionSetupController, inspectionFormController], animated: true)
		} else{
			AlertView.present(on: self, with: "Couldn't proceed because of internal error", delay: 4, offsetY: -50)
		}
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		if selectedIndex == 1{
			return true
		}
		return false
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let action = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
			if let inspection = self.inspections[1]?[indexPath.row]{
				try? inspection.unpin()
				self.inspections[1]?.remove(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .none)
			}
		}
		return [action]
	}
}

//MARK: -
extension InspectionsController{
	fileprivate var selectedIndex: Int{
		return segmentedControl.selectedSegmentIndex
	}
}

//MARK: -
extension InspectionsController{
	static let reference = (AppDelegate.root?.presentedViewController as? UINavigationController)?.viewControllers.first as? InspectionsController
}




