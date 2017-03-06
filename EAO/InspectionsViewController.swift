//
//  InspectionsViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

class InspectionsViewController: CommonViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

//MARK: - Setup
extension InspectionsViewController {
    fileprivate func setup() {
        setNavigationBar(with: .inspections, leftButtonType: .back, rightButtonType: .none)
    }
}
