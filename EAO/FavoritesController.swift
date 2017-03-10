//
//  FavouritesViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit
//h
class FavoritesController: CommonViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var favorites = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...100{
            
            var text = ""
            
            for j in 0...i{
                text += "\(j)"
            }
            
            favorites.append(text)
            tableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .none)
        }
        
    }
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(identifier: "FavoritesCell") as! FavoritesCell
        
        let str = favorites[indexPath.row]
        
        cell.setData(title: str, date: str)
        
        return cell
    }
   
    
}

 
