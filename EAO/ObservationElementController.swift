//
//  ObservationElementController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import Parse
import MapKit

final class ObservationElementController: UIViewController{
	fileprivate var locationManager = CLLocationManager()
	var saveAction: ((PFObservation)->Void)?
	var inspection  : PFInspection!
	var observation : PFObservation!
	var photos		: [PFPhoto]?
	
	//MARK: -
	@IBOutlet fileprivate var indicator: UIActivityIndicatorView!
	@IBOutlet fileprivate var scrollView : UIScrollView!
	@IBOutlet fileprivate var titleTextField: UITextField!
	@IBOutlet fileprivate var requirementTextField: UITextField!
	@IBOutlet fileprivate var descriptionTextView: UITextView!
	@IBOutlet fileprivate var GPSLabel: UIButton!
	@IBOutlet fileprivate var collectionViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet fileprivate var collectionView: UICollectionView!
	@IBOutlet fileprivate var addPhotoButton: UIButton!
	
	//MARK: -
	@IBAction fileprivate func saveTapped(_ sender: UIBarButtonItem) {
		if !validate() { return }
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
//			(self.stackView.subviews[self.photoCounter] as? UIImageView)?.image = image
//			self.photoCounter += 1
//			if self.photoCounter > 4{
//				self.photoCounter = 0
//			}
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
		loadPhotos()
	}
	
	fileprivate func loadPhotos(){
		print("0")
		guard let query = PFPhoto.query() else{
			indicator.stopAnimating()
			return
		}
		print("1")
		query.fromLocalDatastore()
		query.whereKey("observation", equalTo: observation)
		query.findObjectsInBackground(block: { (photos, error) in
			guard let photos = photos as? [PFPhoto], error == nil else {
				print("2")
				self.indicator.stopAnimating()
				AlertView.present(on: self, with: "Couldn't retrieve observation photos")
				return
			}
			if self.photos == nil{
				self.photos = []
			}
			for photo in photos{
				if let id = photo.id{
					let url = URL(fileURLWithPath: FileManager.directory.absoluteString).appendingPathComponent(id, isDirectory: true)
					photo.image = UIImage(contentsOfFile: url.path)
					self.photos?.append(photo)
				}
			}
			print("3")
			self.collectionViewHeightConstraint.constant = Constants.cellWidth
			self.collectionView.reloadData()
			self.indicator.stopAnimating()
		})
	}
}

extension ObservationElementController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
	private func photoCell(indexPath: IndexPath) -> UICollectionViewCell{
		let cell = collectionView.dequeue(identifier: "PhotoCell", indexPath: indexPath) as! ObservationElementPhotoCell
		
		return cell
	}
	
	private func addNewtPhotoCell(indexPath: IndexPath) -> UICollectionViewCell{
		let cell = collectionView.dequeue(identifier: "AddNewPhotoCell", indexPath: indexPath) as! ObservationElementAddNewPhotoCell
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos == nil ? 0 : photos!.count + 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		print("count: \(photos?.count)")
		if indexPath.row == photos?.count{
			return addNewtPhotoCell(indexPath: indexPath)
		}
		return photoCell(indexPath: indexPath)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		return CGSize(width: Constants.cellWidth, height: Constants.cellWidth)
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

extension ObservationElementController{
	fileprivate func validate() ->Bool{
		if titleTextField.text?.isEmpty() == true{
			present(controller: Alerts.fields)
			return false
		}
		
		if requirementTextField.text?.isEmpty() == true {
			present(controller: Alerts.fields)
			return false
		}
		
		if descriptionTextView.text.isEmpty() == true{
			present(controller: Alerts.fields)
			return false
		}
		return true
	}
}

extension ObservationElementController{
	enum Alerts{
		static let fields = UIAlertController(title: "All Fields Required", message: "Please fill out 'Title', 'Requirement', and 'Description' fields")
	}
}

extension ObservationElementController{
	enum Constants{
		static let cellWidth = (UIScreen.width-25)/4
	}
}





