//
//  ObservationElementController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import Parse
import MapKit
class ObservationElementController: UIViewController{
	var inspection: PFInspection!
	var observation: PFObservation!
	fileprivate var locationManager = CLLocationManager()
	
	var saveAction: ((PFObservation)->Void)?
	fileprivate var photoCounter = 0
	//MARK: -
	@IBOutlet fileprivate var indicator: UIActivityIndicatorView!
	@IBOutlet fileprivate var scrollView : UIScrollView!
	@IBOutlet fileprivate var titleTextField: UITextField!
	@IBOutlet fileprivate var requirementTextField: UITextField!
	@IBOutlet fileprivate var descriptionTextView: UITextView!
	@IBOutlet fileprivate var GPSLabel: UIButton!
	@IBOutlet fileprivate var stackView : UIStackView!
	@IBOutlet fileprivate var addPhotoButton: UIButton!
	
	//MARK: -
	@IBAction fileprivate func saveTapped(_ sender: UIBarButtonItem) {
		indicator.startAnimating()
		saveAction?(self.observation)
		observation.title = titleTextField.text
		observation.requirement = requirementTextField.text
		observation.observationDescription = descriptionTextView.text
		if observation.coordinate == nil{
			observation.coordinate = PFGeoPoint(location: locationManager.location)
		}
		if observation.inspection == nil{
			observation.inspection = inspection
		}
		observation.pinInBackground { (success, error) in
			if success && error == nil{
				if self.observation.pinnedAt == nil{
					self.observation.pinnedAt = Date()
				}
				_ = self.navigationController?.popViewController(animated: true)
			} else{
				AlertView.present(on: self, with: "Error occured while saving inspection to local storage")
			}
			self.indicator.stopAnimating()
		}
	}
 
	@IBAction fileprivate func addPhotoTapped(_ sender: UIButton) {
		sender.isEnabled = false
		let uploadPhotoController = UploadPhotoController.storyboardInstance() as! UploadPhotoController
		uploadPhotoController.observation = observation
		uploadPhotoController.uploadPhotoAction = { (image) in
			(self.stackView.subviews[self.photoCounter] as? UIImageView)?.image = image
			self.photoCounter += 1
			if self.photoCounter > 4{
				self.photoCounter = 0
			}
		}
		push(controller: uploadPhotoController)
		sender.isEnabled = true
	}
	
	//MARK: -
	override func viewDidLoad() {
		addDismissKeyboardOnTapRecognizer(on: scrollView)
		populate()
		if observation == nil{
			observation = PFObservation()
		}
		if isReadOnly{
			titleTextField.isEnabled = false
			requirementTextField.isEnabled = false
			descriptionTextView.isEditable = false
			addPhotoButton.isEnabled = false
		}
		GPSLabel.setTitle("GPS: \(observation?.coordinate?.toString() ?? locationManager.coordinateAsString() ?? "Unavailible")", for: .normal)
	}
	
	deinit {
		print("deinit observation")
	}
	
	
	//MARK: -
	fileprivate func populate(){
		guard let observation = observation else { return }
		indicator.startAnimating()
		titleTextField.text = observation.title
		requirementTextField.text = observation.requirement
		descriptionTextView.text = observation.observationDescription
		populatePhotos()
	}
	
	fileprivate func populatePhotos(){
		guard let query = PFPhoto.query() else{
			indicator.stopAnimating()
			return
		}
		
		query.fromLocalDatastore()
		query.whereKey("observation", equalTo: observation)
		query.findObjectsInBackground(block: { (photos, error) in
			print("2")
			guard let photos = photos as? [PFPhoto], error == nil else {
				self.indicator.stopAnimating()
				AlertView.present(on: self, with: "Couldn't retrieve observation images")
				return
			}
			print("3:\(photos.count)")
			for photo in photos{
				if let id = photo.id{
					print("id:\(id)")
					let url = URL(fileURLWithPath: FileManager.directory.absoluteString).appendingPathComponent(id, isDirectory: true)
					(self.stackView.subviews[self.photoCounter] as? UIImageView)?.image = UIImage(contentsOfFile: url.path)
					self.photoCounter += 1
					if self.photoCounter > 4{
						self.photoCounter = 0
					}
				}
			}
			self.indicator.stopAnimating()
		})
	}
	
}

extension ObservationElementController{
	var isReadOnly: Bool{
		return inspection.isSubmitted?.boolValue == true
	}
}

extension ObservationElementController: UITextFieldDelegate{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let tag = textField.tag
		if tag == 1{
			requirementTextField.becomeFirstResponder()
		} else {
			descriptionTextView.becomeFirstResponder()
		}
		return true
	}
}









