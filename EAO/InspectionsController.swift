//
//  InspectionsViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit
import MapKit

class InspectionsController: CommonViewController {
    
    //MARK: IBActions
    @IBAction func ProgressAction(){
        progressA()
    }
    
    @IBAction func UpcomingAction(){
        upcomingA()
    }
    
    @IBAction func SubmittedAction(){
        submittedA()
    }
    
    //MARK: Variables
    @IBOutlet var tableView: CommonTableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}



//MARK: - Setup
extension InspectionsController {
    
    fileprivate func setup() {
        
        setNavigationBar(with: .inspections, leftButtonType: .back, rightButtonType: .none)
        tableView.tableViewType = .inspections
        
        progressA()
        
        let navHeight = navigationController?.navigationBar.frame.size.height
        let map = MKMapView.inspectionMap(tableViewYPos: tableView.frame.origin.y,
                                        NavigationHeight: navHeight!)
        self.view.addSubview(map)
        
    }
    
}

//MARK: Actions
extension InspectionsController {
    
    fileprivate func progressA(){
        
        let arr1 : NSMutableArray = ["Title1","Title2","Jan. 6/14"]
        let arr2 : NSMutableArray = ["Title4","Title5","Jan. 7/14"]
        let arr3 : NSMutableArray = ["Title6","Title7","Jan. 8/14"]
        let arr4 : NSMutableArray = ["Title8","Title9","Jan. 9/14"]
        let arr5 : NSMutableArray = ["Title10","Title11","Jan. 10/14"]
        let arr6 : NSMutableArray = ["Title12","Title13","Jan. 11/14"]
        let tableViewArr : NSMutableArray = [arr1,arr2,arr3,arr4,arr5,arr6]
        
        tableView.dataArray = tableViewArr
        DispatchQueue.main.async{
            self.tableView.reloadData()
            let indexPath : NSIndexPath! = NSIndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
        }
        
    }
    
    fileprivate func upcomingA(){
        
        let arr1 : NSMutableArray = ["stuff","WSDFG56491","Jan. 6/18"]
        let arr2 : NSMutableArray = ["stuff2","ZXCVG00032","Jan. 7/18"]
        let arr3 : NSMutableArray = ["Airial Inspection","X0007","Jan. 8/18"]
        let arr4 : NSMutableArray = ["Dam Inspection","DAM3003","Jan. 9/18"]
        let arr5 : NSMutableArray = ["Wind Turbine Inspection","WTI12345","Jan. 10/18"]
        let arr6 : NSMutableArray = ["Hello","TIAT123","Jan. 11/18"]
        let tableViewArr : NSMutableArray = [arr1,arr2,arr3,arr4,arr5,arr6]
        
        tableView.dataArray = tableViewArr
        DispatchQueue.main.async{
            self.tableView.reloadData()
            let indexPath : NSIndexPath! = NSIndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
        }
        
    }
    
    fileprivate func submittedA(){
        
        let arr1 : NSMutableArray = ["Title1","Title2","Jan. 6/17"]
        let arr2 : NSMutableArray = ["Title4","Title5","Jan. 7/17"]
        let arr3 : NSMutableArray = ["Title6","Title7","Jan. 8/17"]
        let arr4 : NSMutableArray = ["Title8","Title9","Jan. 9/17"]
        let arr5 : NSMutableArray = ["Title10","Title11","Jan. 10/17"]
        let arr6 : NSMutableArray = ["Title12","Title13","Jan. 11/17"]
        let tableViewArr : NSMutableArray = [arr1,arr2,arr3,arr4,arr5,arr6]
        
        tableView.dataArray = tableViewArr
        DispatchQueue.main.async{
            self.tableView.reloadData()
            let indexPath : NSIndexPath! = NSIndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
        }
    }
}



