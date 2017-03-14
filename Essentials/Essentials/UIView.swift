//
//  UIView.swift
//  Vmee
//
//  Created by Micha Volin on 2016-12-23.
//  Copyright © 2016 Vmee. All rights reserved.
//



extension UIView {
 
    public func animateLayoutUsingSpring(duration: Double, dumping: CGFloat, completion: (()->Void)? = nil){
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: dumping, initialSpringVelocity: 0.25, options: .curveLinear, animations: {
            
            self.layoutIfNeeded()
            
        }, completion: { (_) in
            
            completion?()
        })
        
    }
    
    public func animateLayout(duration: Double){
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }
    
    public func loadFromNib() -> UIView? {
        
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        let instances = nib.instantiate(withOwner: self, options: nil)
        let instance = instances.first as? UIView
        
        return instance
    }
    
    public static func loadFromNibWithName(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        let nib = UINib(nibName: nibNamed, bundle: bundle)
        let instances = nib.instantiate(withOwner: nil, options: nil)
        let instance = instances.first as? UIView
        
        return instance
    }
    
    public static func loadFromNib(bundle : Bundle? = nil) -> UIView? {
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let instances = nib.instantiate(withOwner: nil, options: nil)
        let instance = instances.first as? UIView
        
        return instance
    }
    
    
    
}


extension UIView{
    
    @IBInspectable public var masksToBounds: Bool{
        get { return false }
        set {
            
            layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable public var shadowColor: UIColor{
        get { return UIColor.black }
        set {

            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable public var shadowOffsetX: CGFloat{
        get { return 0 }
        set {
 
            layer.shadowOffset.width = newValue
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat{
        get { return 0 }
        set {
            
            layer.shadowOffset.height = newValue
        }
    }
    
    
    @IBInspectable public var shadowOpacity: Float{
        get { return 0 }
        set {
 
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat{
        get { return 0 }
        set {
 
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get { return layer.cornerRadius}
        set {
            
            layer.cornerRadius  = newValue
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get { return layer.borderWidth}
        set {
            
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get { return nil }
        set {
            
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
   
}















