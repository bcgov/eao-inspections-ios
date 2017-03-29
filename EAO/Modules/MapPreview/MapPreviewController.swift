//
//  MapPreviewController.swift
//  EAO
//
//  Created by Micha Volin on 2017-03-15.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import MapKit

class MapPreviewController: UIViewController{
    
    let locationManager = CLLocationManager()
    var addLocationAction: ((_ location: CLLocation?)->Void)?
    
    @IBOutlet var visualEffect: UIVisualEffectView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addLocationView: UIView!
    @IBOutlet var centerPin: UIView!
    
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    
    @IBAction func dismissAddLocationView(_ sender: Any) {
        addLocationView.removeFromSuperview()
        visualEffect.alpha = 0
    }
    
    @IBAction func dropPin(_ sender: UIButton) {
        showAddLocationView()
    }
    
    @IBAction func addLocation(_ sender: UIButton) {
        let location = mapView.coordinate(from: centerPin.center)
        addLocationAction?(location)
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        visualEffect.alpha = 0
        if let location = locationManager.location{
            mapView.setCurrentRegion(location)
            latitudeLabel.text  = "Latitude : \(location.coordinate.latitude)"
            longitudeLabel.text = "Longitude : \(location.coordinate.longitude)"
        }
        addDismissKeyboardOnTapRecognizer(on: view)
    }
    
    func showAddLocationView(){
        view.addSubview(addLocationView)
        
        addLocationView.center = view.center
        addLocationView.transform = CGAffineTransform(translationX: 1.3, y: 1.3)
        addLocationView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.addLocationView.alpha = 1
            self.addLocationView.transform = .identity
            self.visualEffect.alpha = 1
        }
    }
    
}

extension MapPreviewController: MKMapViewDelegate{
    
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("m")
        let coordinate = mapView.coordinate(from: centerPin.center).coordinate
        latitudeLabel.text  = "latitude : \(coordinate.latitude)"
        longitudeLabel.text = "longitude : \(coordinate.longitude)"
    }
    
}





