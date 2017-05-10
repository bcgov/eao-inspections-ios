//
//  PFObservation.swift
//  EAO
//
//  Created by Micha Volin on 2017-04-26.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import Parse
class PFObservation: PFObject, PFSubclassing{
	@NSManaged var title: String?
	@NSManaged var requirement: String?
	@NSManaged var observationDescription: String?
	@NSManaged var coordinate: PFGeoPoint?
	@NSManaged var inspection: PFInspection?
	@NSManaged var pinnedAt: Date?
	static func parseClassName() -> String {
		return "Observation"
	}
}
