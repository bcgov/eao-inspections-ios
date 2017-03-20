//
//  String.swift
//  Vmee
//
//  Created by Micha Volin on 2016-12-15.
//  Copyright © 2016 Vmee. All rights reserved.
//


extension String {
    
    public func count() -> Int{
        return self.characters.count
    }
    
    public func isEmpty() -> Bool{
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        let characters = trimmed.characters
        return characters.isEmpty
    }
 
   public func firstComponent() -> String {
      if let component = self.components(separatedBy: " ").first{
         return component
      }
      
      return self 
   }
   
   public func trimBy(numberOfChar: Int) -> String{
     
      if let to = self.characters.index(self.startIndex, offsetBy: numberOfChar, limitedBy: self.characters.endIndex){
         let trimmedString = self.substring(to: to)
         return trimmedString
      }
      
      return self
   }
   
   public func trimWhiteSpace() -> String{
      return self.trimmingCharacters(in: .whitespacesAndNewlines)
   }
   
   
   public func boolean() -> Bool?{
      guard let int = Int(self) else{
         return nil
      }
      return Bool.init(NSNumber(integerLiteral: int))
   }
   
}



