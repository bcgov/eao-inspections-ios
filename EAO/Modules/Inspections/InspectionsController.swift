//
//  InspectionsViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit
import MapKit

class InspectionsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var inspections = [String]()
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var mapView   : MKMapView!
    
    
    @IBAction func searchTapped(_ sender: UIBarButtonItem) {
        
    }
    
    
    
    @IBAction func ProgressAction(){
        progressA()
    }
    
    @IBAction func UpcomingAction(){
        upcomingA()
    }
    
    @IBAction func SubmittedAction(){
        submittedA()
    }
    
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        progressA()
    }
    
    //MARK:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let previewController = ProjectPreviewController.storyboardInstance() as! ProjectPreviewController
        navigationController?.pushViewController(previewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(identifier: "InspectionCell") as! InspectionCell
        cell.setData(title: inspections[indexPath.row], code: inspections[indexPath.row], date: inspections[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inspections.count
    }
}


//MARK:
extension InspectionsController {
    func progressA(){
        let arr1 = ["Title1","Title2","Jan. 6/14"]
        self.inspections = arr1
        self.tableView.reloadData()
    }
    
    func upcomingA(){
        let arr1 = ["stuff","WSDFG56491","Jan. 6/18"]
        self.inspections = arr1
        self.tableView.reloadData()
    }
    
    func submittedA(){
        let arr1 = ["Title1","Title2","Jan. 6/17"]
        self.inspections = arr1
        self.tableView.reloadData()
    }
}




