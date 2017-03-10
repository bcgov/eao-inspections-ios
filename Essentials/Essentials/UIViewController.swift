//
//  UIViewController.swift
//  Vmee
//
//  Created by Micha Volin on 2016-12-18.
//  Copyright © 2016 Vmee. All rights reserved.
//
 
extension UIViewController{
   
   
   ///Make sure storyboard file has same name as the class name
   public static func storyboardInstance() -> UIViewController?{
      let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
      let controller = storyboard.instantiateInitialViewController()
      return controller
   }
   
   public func present(controller: UIViewController?){
      
      guard let controller = controller else{
         return
      }
      
      present(controller, animated: true, completion: nil)
   }
 
   ///Adds tap gesture recognizer to root view that dismissess keyboard on tap
   public func addDismissKeyboardOnTapRecognizer(){
      let tapRec = UITapGestureRecognizer()
      tapRec.cancelsTouchesInView = false
      tapRec.addTarget(self, action: #selector(dismissKeyboard))
      view.addGestureRecognizer(tapRec)
   }
   
   public func dismissKeyboard(){
      view.endEditing(true)
   }
   
}


extension UIViewController{
    
    
   
   public func addObserver(_ selector: Selector,_ name: String,_ object: AnyObject?=nil){
      NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
   }
   
   public func addKeyboardDidShowNotification(){
      NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
   }
   
   public func addKeyboardWillShowNotification(){
      NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
   }
   
   public func addKeyboardWillHideNotification(){
      NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
   }
   
   open func keyboardDidShow(_ notification: Notification) {}
   
   open func keyboardWillHide(_ notification: Notification) {}
   
   open func keyboardWillShow(_ notification: Notification) {}
   
   ///Removes all observers
   open func removeObservers(){
      NotificationCenter.default.removeObserver(self)
   }
}







