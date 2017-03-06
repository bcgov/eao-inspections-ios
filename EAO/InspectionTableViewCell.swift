//
//  InspectionTableViewCell.swift
//  EAO
//
//  Created by Nicholas Palichuk on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

class InspectionTableViewCell: CommonTableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var title2: UILabel!
    @IBOutlet var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
