//
//  CLLocationManager.swift
//  Vmee
//
//  Created by Micha Volin on 2017-01-02.
//  Copyright © 2017 Vmee. All rights reserved.
//

import MapKit
extension CLLocationManager{
   
   func isAuthorized() ->Bool{
      if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
         return true
      }
      return false
   }
   
}
