//
//  ArrowRightShape.swift
//  Vmee
//
//  Created by Micha Volin on 2017-02-19.
//  Copyright © 2017 Vmee. All rights reserved.
//

@IBDesignable
class ArrowRightShape: UIView{
   
   @IBInspectable var color      : UIColor = UIColor.gray
   @IBInspectable var background : UIColor = UIColor.clear
   
  
   override func draw(_ rect: CGRect) {
      guard let context = UIGraphicsGetCurrentContext() else { return }
      
      backgroundColor = background
      context.setLineWidth(0.5)
      context.move(to: CGPoint(x: rect.maxX/2, y: 0))
      context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY/2))
      context.addLine(to: CGPoint(x: rect.maxX/2, y: rect.maxY))
      
      context.setFillColor(color.cgColor)
      context.strokePath()
   }
   
   
   
}
