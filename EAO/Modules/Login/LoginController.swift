//
//  LoginViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet var usernameT: UITextField!
    @IBOutlet var passwordT: UITextField!
    
    @IBAction func login(){
    
        checkLoginCreds()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LoginController {
    
    fileprivate func checkLoginCreds(){
        
        if usernameT.text != "" && passwordT.text != ""{
            
           
            
        }else{
            
			
            //UIAlertController.simpleAlert(title: "Wrong input", msg: "fix your username or password")
            
        }
        
    }
    
}
