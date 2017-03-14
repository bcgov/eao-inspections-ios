//
//  ProjectsCell.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-13.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

class ProjectsCell: UITableViewCell{
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var nameLabel  : UILabel!
    @IBOutlet var dateLabel  : UILabel!
    
    func setData(title: String?, name: String?, date: String?){
        titleLabel.text = title
        nameLabel.text  = name
        dateLabel.text  = date
    }
    
    
}
