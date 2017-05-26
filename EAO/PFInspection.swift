//
//  PFInspection.swift
//  EAO
//
//  Created by Micha Volin on 2017-04-26.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import Parse

enum PFInspectionError: Error{
	case zeroObservations
}

final class PFInspection: PFObject, PFSubclassing{
	var progress: Float = 0
	var isBeingUploaded = false
	
	@NSManaged var id : String?
	@NSManaged var isSubmitted  : NSNumber?
	@NSManaged var project  : String?
	@NSManaged var title	: String?
	@NSManaged var subtitle : String?
	@NSManaged var subtext  : String?
	@NSManaged var number	: String?
	@NSManaged var start	: Date?
	@NSManaged var end		: Date?
	
	static func parseClassName() -> String {
		return "Inspection"
	}
	
	func submit(completion: @escaping (_ success: Bool,_ error: PFInspectionError?)->Void, block: @escaping (_ progress : Float)->Void){
		var counter = 0
		var objects = [PFObject]()
		PFObservation.load(for: self.id!) { (observations) in
			guard let observations = observations, !observations.isEmpty else{
				completion(false, PFInspectionError.zeroObservations)
				block(0)
				return
			}
			block(0)
			objects.append(contentsOf: observations as [PFObject])
			objects.insert(self as PFObject, at: 0)
			for observation in observations{
				PFPhoto.load(for: observation.id!, result: { (photos) in
					if let photos = photos{
						photos.forEach({ (photo) in
							if let data = photo.get(){
								photo.file = PFFile(data: data)
							}
						})
						objects.append(contentsOf: photos as [PFObject])
					}
					counter += 1
					if counter == observations.count{
						print("finished appending objects:\n\t\(objects.count)\n\n")
						var object_counter = 0
						for object in objects{
							(object as? PFInspection)?.isSubmitted = true
							object.saveInBackground(block: { (success, error) in
								print("\n*object: \(object)\n")
								print("error: \(error)\n")
								print("success:\(success)\n")
								if success && error == nil{
									
								} else{
									
								}
								object_counter += 1
								block(Float(object_counter)/Float(objects.count))
								if object_counter == objects.count{
									print("done")
									block(1)
									delay(0.5, closure: {
										completion(success, nil)
									})
								}
							})
						}
					}
				})
			}
		}
	}
 
	
}
