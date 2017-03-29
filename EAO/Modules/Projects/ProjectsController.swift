//
//  ProjectsViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import MapKit

class ProjectsController: UIViewController {

    @IBOutlet var tableView: UITableView!
   
    var projects = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projects.append("Brucejack Gold Mine")
        tableView.reloadData()
    }
}


extension ProjectsController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let previewController = ProjectPreviewController.storyboardInstance() as! ProjectPreviewController
        navigationController?.pushViewController(previewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(identifier: "ProjectsCell") as! ProjectsCell
        let project = projects[indexPath.row]
        cell.setData(title: "M15-01", name: project, date: "July 5, 2017 - July 8, 2017")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
}







