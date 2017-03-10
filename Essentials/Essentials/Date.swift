//
//  Data.swift
//  Vmee
//
//  Created by Micha Volin on 2017-02-04.
//  Copyright © 2017 Vmee. All rights reserved.
//

extension Date{
   
   
   func invitationFormat() -> String{
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "EEEE, MMM dd"
      return dateFormatter.string(from: self)
   }
}
