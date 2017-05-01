//
//  PFObservation.swift
//  EAO
//
//  Created by Micha Volin on 2017-04-26.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import Parse


class PFObservation: PFObject, PFSubclassing{
	
 
	
	static func parseClassName() -> String {
		return "Observation"
	}
	
	@NSManaged var name: String?
	@NSManaged var address: String?
	@NSManaged var coordinate: PFGeoPoint?
	@NSManaged var type: NSNumber?
	@NSManaged var country: String?
	@NSManaged var range: NSNumber?
 
}
