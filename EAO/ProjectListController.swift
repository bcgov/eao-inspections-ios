//
//  ProjectListController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

class ProjectListController: UIViewController{
	var result: ((_: String?)->Void)?
 
}

extension ProjectListController: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeue(identifier: "ProjectListCell") as! ProjectListCell
		cell.setData(title: "Project 1")
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		result?("Project 1")
		_ = navigationController?.popViewController(animated: true)
	}
}

extension ProjectListController{
	 
	
}
