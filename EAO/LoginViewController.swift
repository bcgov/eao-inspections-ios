//
//  LoginViewController.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

class LoginViewController: CommonViewController {

    @IBOutlet var usernameT: UITextField!
    @IBOutlet var passwordT: UITextField!
    
    @IBAction func login(){
    
        if usernameT.text != "" && passwordT.text != ""{
            
            CommonMethods.hideViewController(viewController:self)
            CommonMethods.showStoryBoard(storyBoard: "TabBar")
            
        }else{
            
            
            CommonMethods.hideViewController(viewController:self)
            CommonMethods.showStoryBoard(storyBoard: "TabBar")
            //UIAlertController.simpleAlert(title: "Wrong input", msg: "fix your username or password")
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
