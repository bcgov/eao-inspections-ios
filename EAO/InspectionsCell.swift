//
//  MainCell.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-29.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

final class InspectionsCell: UITableViewCell{
	@IBOutlet fileprivate var titleLabel : UILabel!
	@IBOutlet fileprivate var timeLabel  : UILabel!
	@IBOutlet fileprivate var editButton : UIButton!
	@IBOutlet fileprivate var uploadButton: UIButton!
	
	func setData(title: String?, time: String?, isReadOnly: Bool){
		titleLabel.text = title
		timeLabel.text  = time
		if isReadOnly{
			editButton.isHidden = true
			uploadButton.isUserInteractionEnabled = false
			uploadButton.setBackgroundImage(#imageLiteral(resourceName: "icon_eye_blue"), for: .normal)
		} else{
			editButton.isHidden = false
			uploadButton.isUserInteractionEnabled = true
			uploadButton.setBackgroundImage(#imageLiteral(resourceName: "icon_upload"), for: .normal)
		}
	}
}
