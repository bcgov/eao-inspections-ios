//
//  InspectionsViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit
import MapKit

class InspectionsViewController: CommonViewController {

    @IBOutlet var tableView: CommonTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

//MARK: - Setup
extension InspectionsViewController {
    fileprivate func setup() {
        
        setNavigationBar(with: .inspections, leftButtonType: .back, rightButtonType: .none)
        
        let arr1 : NSMutableArray = ["Title1","Title2","Jan. 6/14"]
        let arr2 : NSMutableArray = ["Title4","Title5","Jan. 7/14"]
        let arr3 : NSMutableArray = ["Title6","Title7","Jan. 8/14"]
        let arr4 : NSMutableArray = ["Title8","Title9","Jan. 9/14"]
        let arr5 : NSMutableArray = ["Title10","Title11","Jan. 10/14"]
        let arr6 : NSMutableArray = ["Title12","Title13","Jan. 11/14"]
        let tableViewArr : NSMutableArray = [arr1,arr2,arr3,arr4,arr5,arr6]
        
        tableView.tableViewType = .inspections
        
        tableView.dataArray = tableViewArr
        tableView.reloadData()
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        
        let map = MKMapView.inspectionMap(tableViewYPos: tableView.frame.origin.y)
        let mapY = navigationController?.navigationBar.frame.size.height
        map.center = CGPoint(x: map.center.x, y: map.center.y+mapY!)
        self.view.addSubview(map)
        
    }
}
