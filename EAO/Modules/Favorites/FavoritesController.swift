//
//  FavouritesViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import QuickLook


class FavoritesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var favorites = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favorites.append("Schedule A: Certified Project Description")
        tableView.reloadData()
        
    }
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(identifier: "FavoritesCell") as! FavoritesCell
        
        let str = favorites[indexPath.row]
        
        cell.setData(title: str, date: "Mar 26, 2015")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let preview = QLPreviewController()
        preview.dataSource = self
        present(controller: preview)
    }
   
    
}





extension FavoritesController: QLPreviewControllerDataSource{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let path = Bundle.main.path(forResource: "samplePDF", ofType: "pdf")
        let url = NSURL.fileURL(withPath: path!)
        return url as QLPreviewItem
    }
}





