//
//  MapViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: CommonViewController,CLLocationManagerDelegate{

    var locationManager: CLLocationManager?
    let map = MKMapView.simpleFullMap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.view.addSubview(map)
        getPermissions()
    }
    
}
extension MapViewController{
    
    fileprivate func setup() {
        setNavigationBar(with: .map, leftButtonType: .back, rightButtonType: .none)
    }
    
    fileprivate func getPermissions(){
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager!.startUpdatingLocation()
        } else {
            locationManager!.requestWhenInUseAuthorization()
        }
        
    }
    
    //MARK: locationManager Delegate Methods
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("derr")
        let location = locations.first!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 10000, 10000)
        map.setRegion(coordinateRegion, animated: false)
        locationManager?.stopUpdatingLocation()
        locationManager = nil
        
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("NotDetermined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager!.startUpdatingLocation()
        }
        
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Failed to initialize GPS: ", error.localizedDescription)
        
    }
    
}
