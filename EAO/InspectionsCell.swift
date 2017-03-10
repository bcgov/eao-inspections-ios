//
//  InspectionTableViewCell.swift
//  EAO
//
//  Created by Nicholas Palichuk on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

class InspectionCell: CommonTableViewCell {

    @IBOutlet fileprivate var titleL: UILabel!
    @IBOutlet fileprivate var titleL2: UILabel!
    @IBOutlet fileprivate var dateL: UILabel!
    @IBOutlet fileprivate var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        
    }
    
}

extension InspectionTableViewCell{
    
    fileprivate func setup(){
        
        titleL.textColor = UIColor.tableWordColor2
        titleL2.textColor = UIColor.tableWordColor
        dateL.textColor = UIColor.tableWordColor2
        backgroundImage.backgroundColor = UIColor.tableBackgroundCell
        
        layer.masksToBounds = false
        backgroundImage.setShadow()
        
    }
}

extension InspectionCell{
    func setLabels(WithTitle title: String, title2: String, date: String){
        
        titleL.text = title
        titleL2.text = title2
        dateL.text = date
        
    }
    
}
