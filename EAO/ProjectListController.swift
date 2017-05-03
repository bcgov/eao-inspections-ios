//
//  ProjectListController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import Alamofire

final class ProjectListController: UIViewController{
	var result : ((_: String?)->Void)?

	fileprivate var projects : [String]?
	fileprivate var filtered : [String]?
	
	//MARK:-
	@IBOutlet fileprivate var indicator: UIActivityIndicatorView!
	@IBOutlet fileprivate var tableView: UITableView!
	@IBOutlet fileprivate var searchBar: UISearchBar!
	
	//MARK:-
	override func viewDidLoad() {
		load()
		searchBar.returnKeyType = .default
	}
	
	deinit {
		print("deinit project list")
	}
	
	//MARK:-
	fileprivate func filter(with text: String?) -> [String]?{
		guard let text = text else { return nil }
		let filtered = projects?.filter({ (name) -> Bool in
			name.lowercased().hasPrefix(text.lowercased())
		})
		return filtered
	}
	
	fileprivate func load(){
		indicator.startAnimating()
		Alamofire.request("https://projects.eao.gov.bc.ca/api/projects/published").responseJSON { response in
			guard let objects = response.result.value as? [Any] else{
				self.indicator.stopAnimating()
				self.present(controller: Alerts.error)
				return
			}
			var projects = [String?]()
			for case let object as [String: Any] in objects  {
				projects.append(object["name"] as? String)
			}
			self.projects = projects.flatMap({$0})
			self.tableView.reloadData()
			self.indicator.stopAnimating()
		}
	}
	
}

//MARK: -
extension ProjectListController: UISearchBarDelegate{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		filtered = nil
		tableView.reloadData()
		searchBar.resignFirstResponder()
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  		if searchBar.text?.isEmpty() == true { return }
		filtered = filter(with: searchBar.text)
		tableView.reloadData()
	}
}

//MARK: -
extension ProjectListController: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filtered?.count ?? projects?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeue(identifier: "ProjectListCell") as! ProjectListCell
		cell.setData(title: filtered?[indexPath.row] ?? projects?[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		result?(filtered?[indexPath.row] ?? projects?[indexPath.row])
		pop()
	}
}

//MARK: -
extension ProjectListController{
	fileprivate struct Alerts{
		static let error = UIAlertController(title: "Oops...", message: "Projects were not retrieved due to an error.\n Please try again later.")
	}
}


