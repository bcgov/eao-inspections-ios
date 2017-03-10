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
            self.registerNib(withIdentifier: "InspectionsCell")
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
            
            let cell: InspectionCell! = tableView.dequeueReusableCell(withIdentifier: "InspectionsCell", for: indexPath) as! InspectionCell
            
            let labels:NSMutableArray! = dataArray.object(at: indexPath.row) as! NSMutableArray
            let topTitle = labels.object(at: 0)
            let midTitle = labels.object(at: 1)
            let dateText = labels.object(at: 2)
            
            cell.setLabels(WithTitle:topTitle as! String,
                           title2:midTitle as! String,
                           date:dateText as! String)
            
            return cell;

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch tableViewType {
            
        case .inspections:
            
            return 75
            
        }
        
    }
    
}

//MARK: - UITableView Delegate
extension CommonTableView: UITableViewDelegate {}







