//
//  LoginViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import SwiftOverlays

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let authenticationManager = AuthenticationManager()
    
    var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //printFonts()
        
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        if hasLogin {
            if let storedEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String, let storedPassword = authenticationManager.keychainWrapper.myObjectForKey("v_Data") as? String {
                emailField.text = storedEmail
                passwordField.text = storedPassword
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        if !hasLogin {
            emailField.text = ""
            passwordField.text = ""
            if loginButton != nil {
                loginButton.enabled = true

            }
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
        
        let btn = sender as! UIButton
        btn.enabled = false
        loginButton = btn
        showWaitOverlay()
        
        if let email = self.emailField.text, let password = self.passwordField.text {
            authenticationManager.logIn(email, password: password, loggedIn: {
                self.removeAllOverlays()
                self.performSegueWithIdentifier("LoginConfirmed", sender: sender)
            })
        }else {
            print("email/password can't be empty")
        }
    }

}
