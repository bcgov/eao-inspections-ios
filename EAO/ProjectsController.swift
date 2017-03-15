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
        
        for i in 1...100{
            
            var text = ""
            
            for j in 0...i{
                text += "\(j)"
            }
            
            projects.append(text)
            tableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .none)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let formController = InspectionFormController.storyboardInstance()!
        push(controller: formController)
        
    }
    
    
 
}

extension ProjectsController{
    
}

extension ProjectsController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(identifier: "ProjectsCell") as! ProjectsCell
        
        let project = projects[indexPath.row]
        
        
        cell.setData(title: project, name: project, date: project)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    
}







