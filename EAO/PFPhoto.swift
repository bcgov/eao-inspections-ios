//
//  PFPhoto.swift
//  EAO
// //  Created by Micha Volin on 2017-05-08.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import Parse
class PFPhoto: PFObject, PFSubclassing{
	///Use this variable for image caching
	var image : UIImage?
	@NSManaged var photo: PFFile?
	@NSManaged var id: String?
	@NSManaged var caption: String?
	@NSManaged var timestamp: Date?
	@NSManaged var coordinate: PFGeoPoint?
	@NSManaged var observation: PFObservation?
	static func parseClassName() -> String {
		return "Photo"
	}
}
