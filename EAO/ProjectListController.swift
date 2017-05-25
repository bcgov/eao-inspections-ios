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
	fileprivate var filtered : [NSMutableAttributedString]?
	
	//MARK:-
	@IBOutlet fileprivate var indicator: UIActivityIndicatorView!
	@IBOutlet fileprivate var tableView: UITableView!
	@IBOutlet fileprivate var searchBar: UISearchBar!
	
	//MARK:-
	override func viewDidLoad() {
		searchBar.returnKeyType = .default
		load()
	}
	
	deinit {
		print("deinit project list")
	}
	
	//MARK:-
	fileprivate func filter(by search: String?) -> [NSMutableAttributedString]?{
		guard let text = search?.lowercased() else { return nil }
		let filtered = projects?.filter({ (name) -> Bool in
			name.lowercased().contains(text)
		})
		let sorted = filtered?.sorted(by: { (left, right) -> Bool in
			left.map(to: text) > right.map(to: text)
		})
		var array = [NSMutableAttributedString]()
		sorted?.forEach({ (string) in
			let attributed = NSMutableAttributedString(string: string)
			if let range = attributed.string.range(of: text, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil){
				let location = string.distance(from: string.startIndex, to: range.lowerBound)
				let lenght = string.distance(from: range.lowerBound, to: range.upperBound)
				let ns_range = NSRange.init(location: location, length: lenght)
				attributed.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellow, range: ns_range)
			}
			array.append(attributed)
		})
		return array
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
				guard let title = object["name"] as? String else { continue }
				projects.append(title)
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
	
	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
		if projects == nil{
			return false
		}
		return true
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		filtered = nil
		tableView.reloadData()
		searchBar.text = ""
		searchBar.resignFirstResponder()
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.isEmpty() == true{
			self.filtered?.removeAll()
			self.filtered = nil
		} else{
			self.filtered = self.filter(by: searchBar.text)
		}
		self.indicator.stopAnimating()
		self.tableView.reloadData()
	}
}

//MARK: -
extension ProjectListController: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filtered?.count ?? projects?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeue(identifier: "ProjectListCell") as! ProjectListCell
		if filtered == nil{
			cell.titleLabel.text = projects?[indexPath.row]
		} else{
			cell.titleLabel.attributedText = filtered?[indexPath.row]
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		result?(filtered?[indexPath.row].string ?? projects?[indexPath.row])
		pop()
	}
}

//MARK: -
extension ProjectListController{
	fileprivate struct Alerts{
		static let error = UIAlertController(title: "Oops...", message: "Projects were not retrieved due to an error.\n Please try again later.")
	}
}


