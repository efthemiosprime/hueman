//
//  LoginViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import SwiftOverlays

class LoginViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var activityIndicator: ActivityIndicator!
    let firebaseManager = FirebaseManager()
    
    var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //printFonts()
        
        let screenSize = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        
        if screenHeight <= 568 {
            forgotPasswordButton.titleLabel?.font = UIFont(name: Font.SofiaProRegular, size: 11)
        }else {
            forgotPasswordButton.titleLabel?.font = UIFont(name: Font.SofiaProRegular, size: 13)
        }
        

        
        emailField.delegate = self
        passwordField.delegate = self
        
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        if hasLogin {
            if let storedEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String, let storedPassword = firebaseManager.keychainWrapper.myObjectForKey("v_Data") as? String {
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
        activityIndicator.show()
        
        if let email = self.emailField.text, let password = self.passwordField.text {
            firebaseManager.logIn(email, password: password, loggedIn: {
                AuthenticationManager.sharedInstance
                self.activityIndicator.hide()

                self.performSegueWithIdentifier("LoginConfirmed", sender: sender)
                }, onerror: { errorMsg in
                    
                    self.activityIndicator.hide()

                    self.showError(errorMsg)
            })
        }else {
            self.showError("email/password can't be empty")

        }
    }
    
    // Dismissing all editing actions when User Tap or Swipe down on the Main View
    func dismissKeyboard(gesture: UIGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func showError(msg: String) {
        let errorController: ErrorController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("errorID") as? ErrorController)!
        errorController.preferredContentSize = CGSizeMake(300, 150)
        errorController.modalPresentationStyle = UIModalPresentationStyle.Popover
        errorController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        errorController.popoverPresentationController?.delegate = self
        errorController.popoverPresentationController?.sourceView = self.view
        errorController.popoverPresentationController?.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0)
        
        // set up the popover presentation controller
        errorController.errorMsg = msg
        
        self.presentViewController(errorController, animated: true, completion: nil)
    }
    // MARK: - Popover
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }

    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        loginButton.enabled = true
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
