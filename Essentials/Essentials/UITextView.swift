//
//  UITextView.swift
//  Vmee
//
//  Created by Micha Volin on 2017-02-12.
//  Copyright © 2017 Vmee. All rights reserved.
//

extension UITextView{
   
   @IBInspectable var top: CGFloat{
      get {return 0}
      set {textContainerInset.top = newValue}
   }
   
   @IBInspectable var left: CGFloat{
      get {return 0}
      set {textContainerInset.left = newValue}
   }
   
   @IBInspectable var bottom: CGFloat{
      get {return 0}
      set {textContainerInset.bottom = newValue}
   }
   
   @IBInspectable var right: CGFloat{
      get {return 0}
      set {textContainerInset.right = newValue}
   }
   
}
