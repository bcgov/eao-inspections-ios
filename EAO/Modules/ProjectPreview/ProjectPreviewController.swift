//
//  ProjectPreviewController.swift
//  EAO
//
//  Created by Nicholas Palichuk on 2017-03-17.
//  Copyright © 2017 FreshWorks. All rights reserved.
//


//pupu
import UIKit

class ProjectPreviewController: UIViewController {

    @IBAction func startInspecionTapped(_ sender: UIButton) {
        let formController = InspectionFormController.storyboardInstance()!
        push(controller: formController)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
