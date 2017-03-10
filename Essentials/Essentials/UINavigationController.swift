//
//  UINavigationController.swift
//  Essentials
//
//  Created by Micha Volin on 2017-03-06.
//  Copyright © 2017 Vmee. All rights reserved.
//

extension UINavigationController{
    public func push(controller: UIViewController?){
        guard let controller = controller else { return }
        pushViewController(controller, animated: true)
    }
    
}
