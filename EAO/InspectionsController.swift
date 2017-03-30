//
//  EAOInspectionsController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

class InspectionsController: UIViewController{
	
	@IBOutlet var tableView: UITableView!
	
	@IBAction func uploadTapped(_ sender: UIButton) {
		
	}
	
	@IBAction func editTapped(_ sender: UIButton) {
		
	}
	
	override func viewDidLoad() {
		tableView.contentInset.top = 50
		tableView.contentInset.bottom = 70
	}
	
}

extension InspectionsController: UITableViewDelegate, UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeue(identifier: "InspectionsCell") as! InspectionsCell
		
		cell.setData(title: "M15-01", time: "July 5, 2017 - July 8, 2017")
		
		return cell
	}
	
}
