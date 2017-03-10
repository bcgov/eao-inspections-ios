//
//  FavoritesCell.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-09.
//  Copyright © 2017 FreshWorks. All rights reserved.
//


class FavoritesCell: UITableViewCell{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel : UILabel!
    
    func setData(title: String?, date: String?){
        
        titleLabel.text = title
        dateLabel.text = date 
        
    }
    
}
