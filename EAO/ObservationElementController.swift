//
//  ObservationElementController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import MapKit
class ObservationElementController: UIViewController{
	
	var locationManager = CLLocationManager()
	
	@IBOutlet var scrollView : UIScrollView!
	@IBOutlet var stackView  : UIStackView!
	
	@IBOutlet var GPSLabel: UIButton!
	
	var saveAction: (()->Void)?
	
	var counter = 0{
		didSet{
			if counter > 4{
				counter = 4
			}
		}
	}
	
	@IBAction func saveTapped(_ sender: UIBarButtonItem) {
		saveAction?()
		_ = navigationController?.popViewController(animated: true)
	}
 
	@IBAction func addPhotoTapped(_ sender: UIButton) {
		let uploadPhotoController = UploadPhotoController.storyboardInstance() as! UploadPhotoController
		
		uploadPhotoController.uploadPhotoAction = { (image) in
			(self.stackView.subviews[self.counter] as? UIImageView)?.image = image
			self.counter += 1
			
		}
		push(controller: uploadPhotoController)
	}
	
	override func viewDidLoad() {
		addDismissKeyboardOnTapRecognizer(on: scrollView)
		
		GPSLabel.setTitle("GPS: \(locationManager.coordinateAsString() ?? "")", for: .normal)
	}
	
}
