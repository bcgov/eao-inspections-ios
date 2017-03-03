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
        self.dataSource = self
        self.delegate = self
        self.estimatedRowHeight = 66
        self.rowHeight = UITableViewAutomaticDimension
    }

    fileprivate func registerCells() {
        /* Register nibs in here */
        switch tableViewType {
        case .inspections:
            //register inspection table cell(s)
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
            //return home table cell
            break
        }

        return UITableViewCell(style: .default, reuseIdentifier: "Default")
    }
}

//MARK: - UITableView Delegate
extension CommonTableView: UITableViewDelegate {}
