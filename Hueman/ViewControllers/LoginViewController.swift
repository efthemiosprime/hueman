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
        
        emailField.delegate = self
        passwordField.delegate = self
        
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        if hasLogin {
            if let storedEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String, let storedPassword = authenticationManager.keychainWrapper.myObjectForKey("v_Data") as? String {
                emailField.text = storedEmail
                passwordField.text = storedPassword
            }
        }
        
        // Creating Tap Gesture to dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.dismissKeyboard(_:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
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
    
    // Dismissing all editing actions when User Tap or Swipe down on the Main View
    func dismissKeyboard(gesture: UIGestureRecognizer){
        self.view.endEditing(true)
    }

}


extension LoginViewController: UITextFieldDelegate {
    // Dismissing the Keyboard with the Return Keyboard Button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Moving the View up after the Keyboard appears
    func textFieldDidBeginEditing(textField: UITextField) {
        //animateView(true, moveValue: 80)
    }
    
    
    // Moving the View down after the Keyboard disappears
    func textFieldDidEndEditing(textField: UITextField) {
        // animateView(false, moveValue: 80)
    }
    
    
    // Move the View Up & Down when the Keyboard appears
    func animateView(up: Bool, moveValue: CGFloat){
        
        let movementDuration: NSTimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        UIView.commitAnimations()
        
        
    }
}
