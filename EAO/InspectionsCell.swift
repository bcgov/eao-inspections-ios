//
//  InspectionTableViewCell.swift
//  EAO
//
//  Created by Nicholas Palichuk on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

class InspectionCell: UITableViewCell {
    @IBOutlet fileprivate var titleLabel : UILabel!
    @IBOutlet fileprivate var codeLabel  : UILabel!
    @IBOutlet fileprivate var dateLabel  : UILabel!
    
    func setData(title: String?, code: String?, date: String?){
        titleLabel.text = title
        codeLabel.text  = code
        dateLabel.text  = date
    }
}

 
