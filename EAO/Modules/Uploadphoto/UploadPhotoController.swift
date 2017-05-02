//
//  UploadPhotoController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-15.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import MapKit

class UploadPhotoController: UIViewController{
    
    var locationManager = CLLocationManager()
    
    var uploadPhotoAction: ((_ image: UIImage?)-> Void)?
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var gpsLabel: UILabel!
    
    @IBOutlet var imageVIew: UIImageView!
    @IBOutlet var uploadButton : UIButton!
    @IBOutlet var uploadLabel  : UILabel!
    
    //MARK: -
    @IBAction func refreshTimestamp(_ sender: UIButton) {
        timestampLabel.text = Date().timeStampFormat()
    }
    
    @IBAction func refreshGPS(_ sender: UIButton) {
        gpsLabel.text = locationManager.coordinateAsString()
    }
    
    @IBAction func upload(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
        let alert = cameraOptionsController()
        present(controller: alert)
    }
    
    //MARK: -
    override func viewDidLoad() {
        addDismissKeyboardOnTapRecognizer(on: view)
        
        timestampLabel.text = Date().timeStampFormat()
        gpsLabel.text = locationManager.coordinateAsString()
    }
    
}


//MARK: -
extension UploadPhotoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageVIew.image = image
            uploadButton.alpha = 0.25
            uploadLabel.alpha = 0
            uploadPhotoAction?(image)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func media(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }
}

extension UploadPhotoController{
    func cameraOptionsController() -> UIAlertController{
        let alert   = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Take Picture", style: .default, handler: { (_) in
            self.media(sourceType: .camera)
        })
        let library = UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
            self.media(sourceType: .photoLibrary)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addActions([camera,library,cancel])
        return alert
    }
}









