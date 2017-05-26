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
	fileprivate let locationManager = CLLocationManager()
	fileprivate var isBeingUploaded = false
	var inspections = [Int:[PFInspection]]()
	//MARK: - IB Outlets
	@IBOutlet var tableView: UITableView!
	@IBOutlet fileprivate var addNewInspectionButton: UIButton!
	@IBOutlet fileprivate var tableViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet fileprivate var segmentedControl: UISegmentedControl!
	@IBOutlet fileprivate var indicator: UIActivityIndicatorView!
	//MARK: - IB Actions
	@IBAction func uploadTapped(_ sender: UIButton, forEvent event: UIEvent) {
		guard let indexPath = tableView.indexPath(for: event),let inspection = inspections[0]?[indexPath.row] else{
			AlertView.present(on: self, with: "Inspection was not found")
			return
		}
		let alert = UIAlertController(title: "Are You Sure?", message: "You will NOT be able to edit this inspection after submission", yes: {
			self.indicator.startAnimating()
			self.isBeingUploaded = true
			inspection.isBeingUploaded = true
			self.tableView.reloadData()
			inspection.submit(completion: { (success, error) in
				self.indicator.stopAnimating()
				inspection.isBeingUploaded = false
				self.isBeingUploaded = false
				guard success, error == nil else{
					if error == PFInspectionError.zeroObservations{
						AlertView.present(on: self, with: "There are no observation elements in this inspection")
					} else{
						AlertView.present(on: self, with: "Error occured whle uploading")
					}
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
	
	@IBAction func segmentedControlChangedValue(_ sender: UISegmentedControl) {
		addNewInspectionButton.isHidden = selectedIndex == 0 ? false : true
		tableViewBottomConstraint.constant = selectedIndex == 0 ? 10 : -60
		view.layoutIfNeeded()
		tableView.reloadData()
	}
	
	//MARK: -
	override func viewDidLoad() {
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false 
		tableView.contentInset.bottom = 10
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		self.load()
	}
	
	//MARK: -
	func load(){
		let query = PFInspection.query()
		query?.fromLocalDatastore()
		query?.order(byDescending: "pinnedAt")
		query?.findObjectsInBackground(block: { (objects, error) in
			guard let objects = objects as? [PFInspection], error == nil else{
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
			self.inspections = inspections
			self.tableView.reloadData()
		})
	}
	
	///Use this method to prepend an inspection to the 'In Progress' tab
	public func prepend(inspection: PFInspection?){
		if let inspection = inspection{
			print("prepending inspection")
			if self.inspections[0] == nil{
				self.inspections[0] = []
			}
			self.inspections[0]?.insert(inspection, at: 0)
			self.tableView.reloadData()
		}
	}
	
	///Use this method to put an inspection from 'In Progress' tp 'Submitted'
	public func moveToSubmitted(inspection: PFInspection?){
		if let inspection = inspection{
			guard let i = inspections[0]?.index(of: inspection) else{
				return
			}
			print("movingToUploaded")
			self.inspections[0]?.remove(at: i)
			if self.inspections[1] == nil{
				self.inspections[1] = []
			}
			self.inspections[1]?.insert(inspection, at: 0)
			self.tableView.reloadData()
		}
	}
	
	//MARK: -
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Failed to initialize GPS: ", error.localizedDescription)
	}
	
}

//MARK: -
extension InspectionsController: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return inspections[selectedIndex]?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeue(identifier: "InspectionsCell") as! InspectionsCell
		let inspection = inspections[selectedIndex]?[indexPath.row]
		var date = ""
		if let start = inspection?.start, let end = inspection?.end{
			date = "\(start.inspectionFormat()) - \(end.inspectionFormat())"
		}
		cell.setData(title: inspection?.title, time: date, isReadOnly: Bool(NSNumber(integerLiteral: selectedIndex)), progress: inspection?.progress ?? 0, isBeingUploaded: inspection?.isBeingUploaded ?? false, isEnabled: self.isBeingUploaded)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let inspectionSetupController = InspectionSetupController.storyboardInstance() as! InspectionSetupController
		inspectionSetupController.inspection = inspections[selectedIndex]?[indexPath.row]
		push(controller: inspectionSetupController)
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




