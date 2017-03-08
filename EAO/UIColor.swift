//
//  UIColor.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

extension UIColor {
    //MARK: - Navigation
    static var navigationBarColor: UIColor {
        return .init(red: 0x33/0xFF, green: 0x5b/0xFF, blue: 0x9f/0xFF, alpha: 0xFF/0xFF)
    }
    
    static var navigationBarTintColor: UIColor {
        
        return .white
        
    }

    //MARK: - Inpsections
    
    static var tableWordColor: UIColor{
        
        return .init(red: 0x4F/0xFF, green: 0x4F/0xFF, blue: 0x4F/0xFF, alpha: 0xFF/0xFF)
        
    }
    
    static var tableWordColor2: UIColor{
        
        return .init(red: 0x33/0xFF, green: 0x5b/0xFF, blue: 0x9f/0xFF, alpha: 0xFF/0xFF)
        
    }
    
    static var tableBackgroundCell: UIColor{
        
        return .init(red: 0xFE/0xFF, green: 0xFE/0xFF, blue: 0xFE/0xFF, alpha: 0xFE/0xFF)
        
    }
    
    static var tableCellShadow: UIColor{
        
        return .init(red: 0x15/0xFF, green: 0x24/0xFF, blue: 0x55/0xFF, alpha: 0xFF/0xFF)
        
    }
    
    static var inspectionBackground: UIColor{
        
        return .init(red: 0xF2/0xFF, green: 0xF2/0xFF, blue: 0xF2/0xFF, alpha: 0xFF/0xFF)
        
    }
    
    //MARK: - Tab Bar
    
    static var tabWordColor: UIColor{
        
        return .init(white: 0xFF/0xFF, alpha: 1)
        
    }
    
    static var tabBackgroundColor: UIColor{
        
        return .init(red: 0x33/0xFF, green: 0x5b/0xFF, blue: 0x9f/0xFF, alpha: 0xFF/0xFF)
        
    }
    
    static var tabUnselectedBackgroundColor: UIColor{
        
        return .init(white: 0xEF/0xFF, alpha: 1)
        
    }
    
}
