//
//  CommonTableView.swift
//  EAO
//
//  Created by Work on 2017-02-21.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

enum TableViewType: Int {
    case inspections
}

class CommonTableView: UITableView {

    //MARK: - Variables
    var tableViewType: TableViewType = .inspections {
        didSet {
            registerCells()
        }
    }
    var dataArray: NSMutableArray = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
}

//MARK: - Setup
extension CommonTableView {
    fileprivate func setup() {
        
        switch tableViewType {
        case .inspections:
            self.backgroundColor = UIColor.inspectionBackground
            break
        }
        
        self.dataSource = self
        self.delegate = self
        self.estimatedRowHeight = 75
        self.rowHeight = UITableViewAutomaticDimension
    }

    fileprivate func registerCells() {
        /* Register nibs in here */
        switch tableViewType {
        case .inspections:
            self.registerNib(withIdentifier: "InspectionTableViewCell")
            break
        }
    }
}

//MARK: - UITableView DataSource
extension CommonTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewType {
        case .inspections:
            
            let cell: InspectionTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "InspectionTableViewCell", for: indexPath) as! InspectionTableViewCell
            
            let labels:NSMutableArray! = dataArray.object(at: indexPath.row) as! NSMutableArray
            
            
            cell.setLabels(WithTitle:labels.object(at: 0) as! String, title2:labels.object(at: 1) as! String, date:labels.object(at: 2) as! String)
            
            return cell;

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
        
    }
    
}

//MARK: - UITableView Delegate
extension CommonTableView: UITableViewDelegate {}







