//
//  InspectionTableViewCell.swift
//  EAO
//
//  Created by Nicholas Palichuk on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

class InspectionTableViewCell: CommonTableViewCell {

    @IBOutlet fileprivate var titleL: UILabel!
    @IBOutlet fileprivate var titleL2: UILabel!
    @IBOutlet fileprivate var dateL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension InspectionTableViewCell{
    
    func setLabels(WithTitle title: String, title2: String, date: String){
        
        titleL.text = title
        titleL2.text = title2
        dateL.text = date
        
    }
    
}
