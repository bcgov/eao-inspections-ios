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
    @IBOutlet var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleL.textColor = UIColor.tableWordColor
        titleL2.textColor = UIColor.tableWordColor
        dateL.textColor = UIColor.tableWordColor
        backgroundImage.backgroundColor = UIColor.tableBackgroundCell
        
        layer.masksToBounds = false
        
        backgroundImage.layer.masksToBounds = false
        backgroundImage.layer.shadowColor = UIColor.tableCellShadow.cgColor
        backgroundImage.layer.shadowOffset = CGSize(width:0,height:1)
        backgroundImage.layer.shadowOpacity = 0.2
        backgroundImage.layer.shadowRadius = 1.0
        
    }
    
}

extension InspectionTableViewCell{
    
    func setLabels(WithTitle title: String, title2: String, date: String){
        
        titleL.text = title
        titleL2.text = title2
        dateL.text = date
        
    }
    
}
