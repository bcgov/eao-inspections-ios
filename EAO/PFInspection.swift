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
	case someObjectsFailed(Int)
	case inspectionIdNotFound
	case fail
	
	var message: String{
		switch self {
		case .zeroObservations: return "There are no observation elements in this inspection"
		case .someObjectsFailed(let number):
			return "Error: \(number) element(s) failed to upload to the server.\nDon't worry - your elements are still saved locally in your phone and you can view them in the submitted tab."
		case .inspectionIdNotFound: return "Error occured whle uploading"
		case .fail : return "Failed to Upload Inspection"
		}
	}
}

//MARK: -
final class PFInspection: PFObject, PFSubclassing{
	var progress: Float = 0
	var isBeingUploaded = false
	
	fileprivate var failed = [PFObject]()
	
	//MARK: -
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
	
	//MARK: - Submission
	func submit(completion: @escaping (_ success: Bool,_ error: PFInspectionError?)->Void, block: @escaping (_ progress : Float)->Void){
		var objects = [PFObject]()
		self.failed.removeAll()
		guard let id = self.id else{
			block(0)
			completion(false, .inspectionIdNotFound)
			return
		}
		block(0)
		PFObservation.load(for: id) { (observations) in
			guard let observations = observations, !observations.isEmpty else{
				block(0)
				completion(false, .zeroObservations)
				return
			}
			var counter = 0
			objects.append(contentsOf: observations as [PFObject])
			objects.insert(self as PFObject, at: 0)
			for observation in observations{
				guard let observationId = observation.id else{
					self.failed.append(observation)
					//also all the photos
					counter += 1
					if counter == observations.count{
						print("_finished appending objects:\n\t\(objects.count)\n")
						self.save(objects: objects, completion: {
							var success = true
							var _error: PFInspectionError? = .someObjectsFailed(self.failed.count)
							if self.failed.count == objects.count{
								_error = PFInspectionError.fail
								success = false
							} else if self.failed.isEmpty{
								_error = nil
							}
							completion(success, _error)
						}, block: { (progress) in
							block(progress)
						})
					}
					continue
				}
				PFPhoto.load(for: observationId, result: { (photos) in
					if let photos = photos{
						photos.setPFFiles()
						objects.append(contentsOf: photos as [PFObject])
					}
					counter += 1
					if counter == observations.count{
						print("finished appending objects:\n\t\(objects.count)\n")
						self.save(objects: objects, completion: {
							var success = true
							var _error: PFInspectionError? = .someObjectsFailed(self.failed.count)
							if self.failed.count == objects.count{
								_error = PFInspectionError.fail
								success = false
							} else if self.failed.isEmpty{
								_error = nil
							}
							completion(success, _error)
						}, block: { (progress) in
							block(progress)
						})
					}
				})
			}
		}
	}
	
	fileprivate func save(objects: [PFObject], completion: @escaping ()->Void, block: @escaping (_ progress : Float)->Void){
		var object_counter = 0
		for object in objects{
			(object as? PFInspection)?.isSubmitted = true
			object.saveInBackground(block: { (success, error) in
				print("error: \(String(describing: error))\n")
				if success && error == nil{
					
				} else{
					self.failed.append(object)
					(object as? PFInspection)?.isSubmitted = false
					object.pinInBackground()
				}
				object_counter += 1
				block(Float(object_counter)/Float(objects.count))
				if object_counter == objects.count{
					print("done uploading")
					block(1)
					delay(0.5, closure: {
						completion()
					})
				}
			})
		}
	}
}

//MARK: -
extension Array where Element == PFPhoto{
	///Gets photo data from local file, converts it to PFFile, and sets each element's file to corresponding PFFile
	fileprivate func setPFFiles(){
		self.forEach({ (photo) in
			if let data = photo.get(){
				photo.file = PFFile(data: data)
			}
		})
	}
}











