//
//  InspectionForm.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

class InspectionFormController: UIViewController{
	
	var forms = [String]()
	
	@IBOutlet var tableView: UITableView!
	
	
	@IBAction func addTapped(_ sender: UIButton) {
		let observationElementController = ObservationElementController.storyboardInstance() as! ObservationElementController
		observationElementController.saveAction = {
			self.forms.append("new element")
			self.tableView.reloadData()
		}
		push(controller: observationElementController)
	}
	
	override func viewDidLoad() {
		
	}
}


extension InspectionFormController: UITableViewDataSource, UITableViewDelegate{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return forms.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeue(identifier: "InspectionFormCell") as! InspectionFormCell
		cell.setData(number: "\(indexPath.row+1)", title: forms[indexPath.row], time: "July 2016")
		return cell
	}
	
	
}
