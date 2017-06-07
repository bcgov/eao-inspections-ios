//
//  InspectionFormCell_.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

class InspectionFormCell: UITableViewCell{
	@IBOutlet var titleLabel  : UILabel!
	@IBOutlet var numberLabel : UILabel!
	@IBOutlet var timeLabel   : UILabel!
	@IBOutlet var editButton: UIButton!
	
	func setData(number: String?, title: String?, time: String?, isReadOnly: Bool){
		titleLabel.text  = title
		numberLabel.text = number
		timeLabel.text   = time

		if isReadOnly{
			editButton.isHidden = true
		} else{
			editButton.isHidden = false 
		}
	}
	
}
