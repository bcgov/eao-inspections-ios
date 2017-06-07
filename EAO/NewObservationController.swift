//
//  ObservationElementController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-30.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import Parse
import MapKit

final class NewObservationController: UIViewController{

	let maximumNumberOfPhotos = 20

	fileprivate var locationManager = CLLocationManager()
	var saveAction  : ((PFObservation)->Void)?
	var inspection  : PFInspection!
	var observation : PFObservation!
	var photos		: [PFPhoto]?

	//MARK: -
	@IBOutlet fileprivate var arrow_0: UIImageView!
	@IBOutlet fileprivate var descriptionButtonHeightConstraint: NSLayoutConstraint!
	@IBOutlet fileprivate var indicator: UIActivityIndicatorView!
	@IBOutlet fileprivate var scrollView : UIScrollView!
	@IBOutlet fileprivate var titleTextField: UITextField!
	@IBOutlet fileprivate var requirementTextField: UITextField!
	@IBOutlet fileprivate var GPSLabel: UIButton!
	@IBOutlet fileprivate var collectionViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet fileprivate var collectionView: UICollectionView!
	@IBOutlet fileprivate var descriptionButton: UIButton!

	//MARK: -
	@IBAction func addVoiceTapped(_ sender: UIButton) {
		present(controller: UIAlertController(title: "This feature is coming soon", message: nil))
	}

	@IBAction func addVideoTapped(_ sender: UIButton) {
		present(controller: UIAlertController(title: "This feature is coming soon", message: nil))
	}

	@IBAction func backTapped(_ sender: UIBarButtonItem) {
		if isReadOnly{
			pop()
			return
		}
		present(controller: UIAlertController(title: "Would you like to save data?", message: nil, yes: {
			self.saveTapped(sender)
		}, cancel: { 
			self.pop()
		}))
	}


	@IBAction fileprivate func saveTapped(_ sender: UIBarButtonItem) {
		if !validate() { return }
		indicator.startAnimating()
		saveAction?(self.observation)
		observation.title = titleTextField.text
		observation.requirement = requirementTextField.text
		observation.observationDescription = descriptionButton.title(for: .normal)
		if observation.coordinate == nil{
			observation.coordinate = PFGeoPoint(location: locationManager.location)
		}
		if observation.inspectionId == nil{
			observation.inspectionId = inspection.id
		}
		if observation.id == nil{
			observation.id = UUID().uuidString
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
 
	@IBAction func descriptionTapped(_ sender: UIButton) {
		let textViewController = TextViewController.storyboardInstance() as! TextViewController
		if sender.title(for: .normal) != "Tap to enter description"{
			textViewController.initialText = sender.title(for: .normal)
		}
		textViewController.title = "Element Description"
		textViewController.result = { (text) in
			if sender.title(for: .normal) == "Tap to enter description"{
				if let text = text, !text.isEmpty(){
					sender.setTitle(text, for: .normal)
				}
			} else{
				if let text = text,!text.isEmpty() {
					sender.setTitle(text, for: .normal)
				} else{
					sender.setTitle("Tap to enter description", for: .normal)
				}
			}
		}
		push(controller: textViewController)
	}
	
	@IBAction fileprivate func addPhotoTapped(_ sender: UIButton) {
		sender.isEnabled = false
		if observation.id == nil{
			observation.id = UUID().uuidString
		}
		let uploadPhotoController = UploadPhotoController.storyboardInstance() as! UploadPhotoController
		uploadPhotoController.observation = observation
		uploadPhotoController.uploadPhotoAction = { (photo) in
			if let photo = photo{
				if self.photos == nil{
					self.photos = []
				}
				self.photos?.append(photo)
			}
			self.collectionViewHeightConstraint.constant = self.getConstraintHeight()
			self.view.layoutIfNeeded()
			self.collectionView.reloadData()
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
			navigationItem.rightBarButtonItem = nil
			titleTextField.isEnabled = false
			requirementTextField.isEnabled = false
			descriptionButton.isEnabled = false
			arrow_0.isHidden = true
			descriptionButtonHeightConstraint.constant = (observation.observationDescription ?? "").height(for: UIScreen.width, font: UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)) + 60
			descriptionButton.titleLabel?.numberOfLines = 0
		}
		GPSLabel.setTitle("GPS: \(observation?.coordinate?.toString() ?? locationManager.coordinateAsString() ?? "unavailable")", for: .normal)
	}

	//MARK: -
	fileprivate func populate(){
		guard let observation = observation else {
			self.photos = []
			self.collectionViewHeightConstraint.constant = Constants.cellWidth
			self.view.layoutIfNeeded()
			return
		}
		indicator.startAnimating()
		titleTextField.text = observation.title
		requirementTextField.text = observation.requirement
		descriptionButton.setTitle(observation.observationDescription, for: .normal)
		loadPhotos()
	}
	
	fileprivate func loadPhotos(){
		guard let query = PFPhoto.query() else{
			indicator.stopAnimating()
			return
		}
		query.fromLocalDatastore()
		query.whereKey("observationId", equalTo: observation.id!)
		query.findObjectsInBackground(block: { (photos, error) in
			guard let photos = photos as? [PFPhoto], error == nil else {
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
			self.collectionViewHeightConstraint.constant = self.getConstraintHeight()
			self.view.layoutIfNeeded()
			self.collectionView.reloadData()
			self.indicator.stopAnimating()
		})
	}
	
	fileprivate func getConstraintHeight()->CGFloat{
		guard let photosCount = photos?.count else { return 0 }
		if photosCount == 0{
			return Constants.cellWidth
		}
		var numberOfRows = Double(photosCount+(isReadOnly ? 0 :1))
		numberOfRows	/= Double(Constants.itemsPerRow)
		numberOfRows	 = ceil(numberOfRows)
		var height = CGFloat(numberOfRows)
		height	  *= Constants.cellWidth
		height    += CGFloat(numberOfRows-1)*5
		return height
	}
}


extension NewObservationController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
	private func photoCell(indexPath: IndexPath) -> UICollectionViewCell{
		let cell = collectionView.dequeue(identifier: "PhotoCell", indexPath: indexPath) as! ObservationElementPhotoCell
		cell.setData(image: photos?[indexPath.row].image)
		return cell
	}
	
	private func addNewtPhotoCell(indexPath: IndexPath) -> UICollectionViewCell{
		let cell = collectionView.dequeue(identifier: "AddNewPhotoCell", indexPath: indexPath) as! ObservationElementAddNewPhotoCell
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if isReadOnly{
			return photos?.count ?? 0
		}
		return photos == nil ? 0 : photos!.count + 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.row == photos?.count && !isReadOnly{
			return addNewtPhotoCell(indexPath: indexPath)
		}
		return photoCell(indexPath: indexPath)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if photos?.count == maximumNumberOfPhotos{
			present(controller: UIAlertController(title: "You've reached maximum (\(maximumNumberOfPhotos)) number of photos", message: nil))
			return
		}
		if indexPath.row == photos?.count{
			return
		}
		let uploadPhotoController = UploadPhotoController.storyboardInstance() as! UploadPhotoController
		uploadPhotoController.isReadOnly = inspection.isSubmitted?.boolValue ?? false
		uploadPhotoController.observation = observation
		uploadPhotoController.photo = photos?[indexPath.row]
		push(controller: uploadPhotoController)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: Constants.cellWidth, height: Constants.cellWidth)
	}
}

extension NewObservationController{
	var isReadOnly: Bool{
		return inspection.isSubmitted?.boolValue == true
	}
}

extension NewObservationController: UITextFieldDelegate{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

extension NewObservationController{
	fileprivate func validate() ->Bool{
		if titleTextField.text?.isEmpty() == true{
			present(controller: Alerts.fields)
			return false
		}
		if requirementTextField.text?.isEmpty() == true {
			present(controller: Alerts.fields)
			return false
		}
		if descriptionButton.title(for: .normal) == "Tap to enter description"{
			present(controller: Alerts.fields)
			return false
		}
		return true
	}
}

extension NewObservationController{
	enum Alerts{
		static let fields = UIAlertController(title: "All Fields Required", message: "Please fill out 'Title', 'Requirement', and 'Description' fields")
	}
}

extension NewObservationController{
	enum Constants{
		static let cellWidth = (UIScreen.width-25)/CGFloat(Constants.itemsPerRow)
		static let itemsPerRow = 4
	}
}





