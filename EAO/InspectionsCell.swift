//
//  MainCell.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-29.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

class InspectionsCell: UITableViewCell{
	@IBOutlet var titleLabel : UILabel!
	@IBOutlet var timeLabel  : UILabel!
	@IBOutlet var editButton : UIButton!
	
	func setData(title: String?, time: String?){
		titleLabel.text = title
		timeLabel.text  = time
	}
}
