//
//  SignupController.swift
//  Hueman
//
//  Created by Efthemios Prime on 3/26/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class SignupController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



    @IBAction func loginAction(sender: UIButton) {
        self.performSegueWithIdentifier("backToLogin", sender: self)

    }
    
    

}
