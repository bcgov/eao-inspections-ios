//
//  UIAlertController.swift
//  Essentials
//
//  Created by Micha Volin on 2017-02-24.
//  Copyright © 2017 Vmee. All rights reserved.
//

extension UIAlertController{
    
    public func addActions(_ actions: [UIAlertAction]){
        for action in actions {
            addAction(action)
        }
    }
    
    public static func custom(title: String?, message: String?, handler: (()->Void)?) -> UIAlertController{
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "Okay", style: .cancel, handler: { (_) in
            handler?()
        })
        
        alert.addAction(okay)
        
        return alert
        
    }
    
}
