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
	@IBOutlet var addButton: UIButton!
	@IBOutlet var indicator: UIActivityIndicatorView!
	@IBOutlet var tableView: UITableView!
	
	@IBAction func saveTapped(_ sender: UIBarButtonItem) {
		present(controller: UIAlertController(title: "Tip", message: "You may save this inspection and edit it later before submission", handler: {
			self.navigationController?.popToRootViewController(animated: true)
		}))
	}
	//MARK: -
	@IBAction func submitTapped(_ sender: UIBarButtonItem) {
		sender.isEnabled = false
		let alert = UIAlertController(title: "Are You Sure?", message: "You will NOT be able to edit this inspection after submission", yes: {
			self.indicator.startAnimating()
			self.setElements(enabled: false)
			self.inspection.isSubmitted = true
			self.inspection.saveEventually()
			var counter = 0
			for observation in self.observations{
				observation.saveEventually()
				let query = PFPhoto.query()
				query?.fromLocalDatastore()
				query?.whereKey("observation", equalTo: observation)
				query?.findObjectsInBackground(block: { (photos, error) in
					for case let photo as PFPhoto in photos ?? []{
						if let id = photo.id{
							let url = URL(fileURLWithPath: FileManager.directory.absoluteString).appendingPathComponent(id, isDirectory: true)
							if let data = try? Data(contentsOf: url){
								photo.photo = PFFile(data: data)
							}
						}
						photo.saveInBackground(block: { (success, error) in
							print("\ns:\(success)\n")
							print("\ne:\(error)\n")
						})
					 
					}
					counter += 1
					if counter == self.observations.count{
						InspectionsController.reference?.moveToSubmitted(inspection: self.inspection)
						self.navigationController?.popToRootViewController(animated: true)
					}
				})
			}
		}) { sender.isEnabled = true }
		present(controller: alert)
	}
	
	@IBAction func addTapped(_ sender: UIButton) {
		let observationElementController = ObservationElementController.storyboardInstance() as! ObservationElementController
		observationElementController.inspection = inspection
		observationElementController.saveAction = { (observation) in
			self.observations.insert(observation, at: 0)
			self.tableView.reloadData()
		}
		push(controller: observationElementController)
	}
	
	//MARK: -
	override func viewDidLoad() {
		if isReadOnly{
			addButton.isEnabled = false
			navigationItem.rightBarButtonItem = nil
		}
		load()
	}
	
	deinit{
		print("deinit Inspection Form")
	}
	
	
	
	fileprivate func getPhotos(result: @escaping (_ photos: [PFPhoto]?)->Void){
		
	}
	
	fileprivate func load(){
		let query = PFObservation.query()
		query?.fromLocalDatastore()
		query?.whereKey("inspection", equalTo: inspection)
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
		return observations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeue(identifier: "InspectionFormCell") as! InspectionFormCell
		cell.setData(number: "\(indexPath.row+1)", title: observations[indexPath.row].title, time: observations[indexPath.row].createdAt?.inspectionFormat())
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let observationElementController = ObservationElementController.storyboardInstance() as! ObservationElementController
		observationElementController.inspection = inspection
		observationElementController.observation = observations[indexPath.row]
		observationElementController.saveAction = { (_) in
			self.tableView.reloadData()
		}
		push(controller: observationElementController)
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



