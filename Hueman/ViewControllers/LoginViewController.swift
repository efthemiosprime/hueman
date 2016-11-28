//
//  LoginViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let authenticationManager = AuthenticationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //printFonts()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func printFonts() {
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNamesForFamilyName(familyName)
            print("Font Names = [\(names)]")
        }
    }
    
    @IBAction func didTapLogin(sender: AnyObject) {
        if let email = self.emailField.text, let password = self.passwordField.text {
            authenticationManager.logIn(email, password: password, loggedIn: {
                self.performSegueWithIdentifier("LoginConfirmed", sender: sender)
            })
        }else {
            print("email/password can't be empty")
        }
    }

}
