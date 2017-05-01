//
//  ProjectListController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import Alamofire

final class ProjectListController: UIViewController{
	var result: ((_: String?)->Void)?
	var names = [String]()
	
	//MARK:-
	@IBOutlet var indicator: UIActivityIndicatorView!
	@IBOutlet var tableView: UITableView!
	
	
	override func viewDidLoad() {
		load()
	}
	deinit {
		print("deinit project list")
	}
	
	private func load(){
		indicator.startAnimating()
		Alamofire.request("https://projects.eao.gov.bc.ca/api/projects/published").responseJSON { response in
			guard let objects = response.result.value as? [Any] else{
				self.indicator.stopAnimating()
				self.present(controller: Alerts.error)
				return
			}
			var names = [String?]()
			for case let object as [String: Any] in objects  {
				names.append(object["name"] as? String)
			}
			self.names = names.flatMap({$0})
			self.tableView.reloadData()
			self.indicator.stopAnimating()
		}
	}
	
}

//MARK:-
extension ProjectListController: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return names.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeue(identifier: "ProjectListCell") as! ProjectListCell
		cell.setData(title: names[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		result?(names[indexPath.row])
		pop()
	}
}

extension ProjectListController{
	struct Alerts{
		static let error = UIAlertController(title: "Oops...", message: "Projects were not retrieved due to an error.\n Please try again later.")
	}
}


