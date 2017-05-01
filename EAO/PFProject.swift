//
//  PFProject.swift
//  EAO
//
//  Created by Micha Volin on 2017-04-27.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import Parse

class PFProject: PFObject, PFSubclassing{
	static func parseClassName() -> String {
		return "Project"
	}
	
	
	
	@NSManaged var isSubmitted : NSNumber?
	@NSManaged var project  : String?
	@NSManaged var title	: String?
	@NSManaged var subtitle : String?
	@NSManaged var subtext  : String?
	@NSManaged var number	: String?
	@NSManaged var start	: Date?
	@NSManaged var end		: Date?
}
