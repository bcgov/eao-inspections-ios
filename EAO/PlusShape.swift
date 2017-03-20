//
//  Plus.swift
//  Vmee
//
//  Created by Micha Volin on 2017-02-13.
//  Copyright © 2017 Vmee. All rights reserved.
//

@IBDesignable
class PlusShape: UIView{
   
   override func draw(_ rect: CGRect) {
      let path = UIBezierPath(ovalIn: rect)
      UIColor(white: 1, alpha: 0.9).setFill()
      path.fill()
      
      
      let plusPath = UIBezierPath()
      
      plusPath.lineWidth = 0.8
      
      
      plusPath.move(to: CGPoint(
         x:10,
         y:10))
      
      plusPath.addLine(to: CGPoint(
         x:bounds.width-10,
         y:bounds.height-10))
      
      plusPath.move(to: CGPoint(
         x:bounds.width-10,
         y: 10))
      
      
      plusPath.addLine(to: CGPoint(
         x:10,
         y:bounds.height-10))
      
      UIColor.black.setStroke()
      
      plusPath.stroke()
      
   }
   
}

