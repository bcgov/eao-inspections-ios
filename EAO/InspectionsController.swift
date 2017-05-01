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
	let locationManager = CLLocationManager()
	var inspections = [Int:[PFInspection]]()
	//MARK: -
	@IBOutlet var addNewInspectionButton: UIButton!
	@IBOutlet var segmentedControl: UISegmentedControl!
	@IBOutlet var tableView: UITableView!
	
	//MARK: -
	@IBAction func segmentedControlChangedValue(_ sender: UISegmentedControl) {
		addNewInspectionButton.isHidden = selectedIndex == 0 ? false : true
		tableView.reloadData()
	}
	
	//MARK: -
	override func viewDidLoad() {
		tableView.contentInset.bottom = 70
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		self.load()
	}
	
	//MARK: -
	func load(){
		let query = PFInspection.query()
		query?.fromLocalDatastore()
		query?.order(byDescending: "updatedAt")
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
			print("prepenfin inspection")
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
		cell.setData(title: inspection?.title, time: date, isReadOnly: Bool.init(NSNumber(integerLiteral: selectedIndex)))
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let inspectionSetupController = InspectionSetupController.storyboardInstance() as! InspectionSetupController
		inspectionSetupController.inspection = inspections[selectedIndex]?[indexPath.row]
		push(controller: inspectionSetupController)
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




