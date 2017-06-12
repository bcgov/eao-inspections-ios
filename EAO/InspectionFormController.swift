//
//  InspectionForm.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import Parse
final class InspectionFormController: UIViewController{
	var inspection : PFInspection!
	var observations = [PFObservation]()
	
	//MARK: -
	@IBOutlet fileprivate var addButton : UIButton!
	@IBOutlet fileprivate var indicator : UIActivityIndicatorView!
	@IBOutlet fileprivate var tableView : UITableView!
	@IBOutlet fileprivate var submitButton: UIButton!
	
	
	@IBAction fileprivate func submitTapped(_ sender: UIButton) {
		sender.isEnabled = false
		guard let index = InspectionsController.reference?.inspections[0]?.index(of: inspection) else{
			sender.isEnabled = true
			return
		}
		navigationController?.popToViewController(InspectionsController.reference!, animated: true)
		InspectionsController.reference?.submit(inspection: inspection, indexPath: IndexPath(row: index, section: 0))
		sender.isEnabled = true
	}
	
	@IBAction fileprivate func editInspectionSetUpTapped(_ sender: UIButton) {
		sender.isEnabled = false
		pop()

	}
	
	@IBAction fileprivate func backTapped(_ sender: UIBarButtonItem) {
		sender.isEnabled = false
		navigationController?.popToRootViewController(animated: true)
		//navigationController?.popToViewController(InspectionsController.reference!, animated: true)
	}
	
	@IBAction fileprivate func saveTapped(_ sender: UIBarButtonItem) {
		present(controller: UIAlertController(title: "Tip", message: "You may save this inspection and edit it later before submission", handler: {
			self.navigationController?.popToRootViewController(animated: true)
		}))
	}

	@IBAction fileprivate func addTapped(_ sender: UIButton) {
		sender.isEnabled = false
		let observationElementController = NewObservationController.storyboardInstance() as! NewObservationController
		observationElementController.inspection = inspection
		observationElementController.saveAction = { (observation) in
			self.observations.insert(observation, at: 0)
			self.tableView.reloadData()
		}
		push(controller: observationElementController)
		sender.isEnabled = true
	}
	
	//MARK: -
	override func viewDidLoad() {
		tableView.contentInset.bottom = 120
		if isReadOnly{
			submitButton.isHidden = true 
			addButton.isHidden = true 
			navigationItem.rightBarButtonItem = nil
		}

		if InspectionsController.reference?.isBeingUploaded == true {
			submitButton.isHidden = true
		}

		load()
	}
 
	fileprivate func load(){
		let query = PFObservation.query()
		query?.fromLocalDatastore()
		query?.whereKey("inspectionId", equalTo: inspection.id!)
		query?.order(byDescending: "pinnedAt")
		query?.findObjectsInBackground(block: { (objects, error) in
			guard let objects = objects as? [PFObservation], error == nil else{
				AlertView.present(on: self, with: "Error occured while retrieving inspections from local storage")
				return
			}
			self.observations = objects
			self.tableView.reloadData()
		})
	}
	
	fileprivate func setElements(enabled: Bool){
		view.isUserInteractionEnabled = enabled
		enabled ? indicator.stopAnimating() : indicator.startAnimating()
		navigationItem.leftBarButtonItem?.isEnabled = enabled
	}
}

//MARK: -
extension InspectionFormController: UITableViewDataSource, UITableViewDelegate{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0{
			return 1
		}
		return observations.count
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeue(identifier: "InspectionFormHeaderCell")!
			if isReadOnly{
				(cell.contentView.subviews.first as? UIButton)?.setTitle("View Inspection Set Up", for: .normal)
			} else{
				(cell.contentView.subviews.first as? UIButton)?.setTitle("Edit Inspection Set Up", for: .normal)
			}
			return cell
		}
		let cell = tableView.dequeue(identifier: "InspectionFormCell") as! InspectionFormCell
		cell.setData(number: "\(indexPath.row+1)", title: observations[indexPath.row].title, time: observations[indexPath.row].createdAt?.inspectionFormat(),isReadOnly: isReadOnly)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0{
			return
		}
		if observations[indexPath.row].id == nil{
			return
		}
		
		let observationElementController = NewObservationController.storyboardInstance() as! NewObservationController
		observationElementController.inspection = inspection
		observationElementController.observation = observations[indexPath.row]
		observationElementController.saveAction = { (_) in
			self.tableView.reloadData()
		}
		push(controller: observationElementController)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0{
			return 70
		}
		return 80
	}
}

//MARK: -
extension InspectionFormController{
	fileprivate var isReadOnly: Bool{
		return inspection.isSubmitted?.boolValue == true
	}
}

//MARK: -
extension InspectionFormController{
	struct Alerts{
		static let error = UIAlertController(title: "ERROR!", message: "Inspection failed to be uploaded to the server.\nPlease try again")
	}
}



