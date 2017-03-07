//
//  MKMapView.swift
//  EAO
//
//  Created by Nicholas Palichuk on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {

    class func simpleFullMap() -> MKMapView{
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let mapView = MKMapView()
        
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 0
        let mapWidth:CGFloat = screenSize.width
        let mapHeight:CGFloat = screenSize.height
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        return mapView
        
    }
    
    class func inspectionMap(tableViewYPos: CGFloat) -> MKMapView{
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let mapView = MKMapView()
        
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 50
        let mapWidth:CGFloat = screenSize.width
        let mapHeight:CGFloat = tableViewYPos - 50
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        return mapView
        
    }
    
}
