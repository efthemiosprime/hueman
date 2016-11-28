//
//  SignupViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var bioField: UITextView!
    
    var authenticationManager = AuthenticationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBAction func didCreateUser(sender: AnyObject) {
        if let email = self.emailField.text, let password = self.passwordField.text, let name = nameField.text,
            let dob = dobField.text, let location = locationField.text, let bio = bioField.text{
                
            let user = User(name: name, email: email, password: password, dob: dob, location: location, bio: bio)
            authenticationManager.signUp(user, completion: {
                self.performSegueWithIdentifier("SignUpComplete", sender: sender)
            })
        
        }else {
            print("any of the fields can't be empty")
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
