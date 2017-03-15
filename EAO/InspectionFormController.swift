//
//  InspectionFormController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-15.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import MapKit
class InspectionFormController: UIViewController{
    
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var mapView    : MKMapView!
    
    @IBOutlet var photoButton: UIButton!
    
    @IBAction func descriptionButtonOneTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let alertController =  descriptionOptionsController(result: { (title) in
            if let title = title {
                sender.setTitle(title, for: .normal)
            }
            sender.isEnabled = true
        })
        present(controller: alertController)
    }
    
    @IBAction func descriptionButtonTwoTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let alertController =  descriptionOptionsController(result: { (title) in
            if let title = title {
                sender.setTitle(title, for: .normal)
            }
            sender.isEnabled = true
        })
        present(controller: alertController)
    }
    
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        let uploadPhotoController = UploadPhotoController.storyboardInstance() as! UploadPhotoController
        uploadPhotoController.uploadPhotoAction = { (image) in
            self.photoButton.setImage(image, for: .normal)
        }
        push(controller: uploadPhotoController)
    }
    
    
    @IBAction func mapTapped(_ sender: UITapGestureRecognizer) {
        let mapPreviewController = MapPreviewController.storyboardInstance() as! MapPreviewController
        mapPreviewController.addLocationAction = { (location) in
            self.mapView.setCurrentRegion(location)
            if let coordinate = location?.coordinate{
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                self.mapView.addAnnotation(annotation)
            }
            
            
        }
        
        push(controller: mapPreviewController)
    }
    
    
    
    override func viewDidLoad() {
        addDismissKeyboardOnTapRecognizer(on: view)
        
    }
    
    
    
    
}

 

extension InspectionFormController{
    
    
    func descriptionOptionsController(result: @escaping (_ title: String?)->Void) -> UIAlertController{
        let alert   = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        var actions = [UIAlertAction]()
        let titles  = ["Enforcement Action", "Condition", "Document", "Custom"]
        
        for i in 0...titles.count-1{
            actions.append(UIAlertAction(title: titles[i], style: .default, handler: { (_) in
                result(titles[i])
            }))
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            result(nil)
        })
        actions.append(cancel)
        alert.addActions(actions)
        return alert
    }
    
}










