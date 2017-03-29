//
//  InspectionFormController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-15.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import MapKit
class InspectionFormController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var items = [String]()
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        items.append("item \(items.count)")
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(item: items.count-1, section: 0), at: .top, animated: true)
    }
   
    //MARK: -
    override func viewDidLoad() {
        addDismissKeyboardOnTapRecognizer(on: view)
        items.append("item")
    }
    
    
    //MARK: -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(identifier: "InspectionFormCell", indexPath: indexPath) as! InspectionFormCell
        cell.parent = self
        cell.titleLabel.text = items[indexPath.row]
        return cell
    }
}

 












