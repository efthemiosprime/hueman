//
//  LoginViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftOverlays

class LoginViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
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
        
        
        // -------------------------------
        // FACEBOOK LOGIN
       // facebookLogin()
        // -------------------------------
        
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
    
            for viewController in self.childViewControllers {
                print("controller: \(viewController)")
            }
        
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
               // AuthenticationManager.sharedInstance
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
        activityIndicator.hide()
        let errorController: ErrorController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("errorID") as? ErrorController)!
      // errorController.preferredContentSize = CGSizeMake(300, 150)
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
        if loginButton != nil {
            loginButton.enabled = true
        }
    }
    
    // MARK: - Facebook Login
    func facebookLogin() {
        let signupFrame = signupButton.frame
        let facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_about_me"]
        view.addSubview(facebookLoginButton)
        facebookLoginButton.frame = CGRectMake(signupFrame.origin.x, signupFrame.origin.y + signupFrame.size.height + 8, signupFrame.size.width, signupFrame.size.height)
     //   facebookLoginButton.delegate = self
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("did logout")
    }
    
    @IBAction func facebookLoginAction(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["email", "public_profile", "user_about_me"], fromViewController: self, handler: {
            (result, error) in
            
            self.activityIndicator.show()


            guard error == nil else {
                print(error)
                self.showError(error.localizedDescription)
                return
            }
            
            if result.isCancelled {
                self.showError("cancelled")
                return
            }
            
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,picture.width(480).height(480)"], tokenString: result.token.tokenString, version: "v2.4", HTTPMethod: "GET")
            req.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                
                if(error == nil)
                {
                    print(result)
                    if (result.valueForKey("email") as? String) != nil {
                        if let picture = result["picture"] {
                            if let data = picture!["data"]{
                                if let url = data!["url"] as? String {

                                    self.firebaseManager.loginWithFacebook(url, loggedIn: {
                                        
                                        self.performSegueWithIdentifier("LoginConfirmed", sender: sender)
                                        
                                        self.activityIndicator.hide()


                                    })

                                }
                            }
                        }
                    }else {
                        self.showError("authorize facebook to use email")
                        self.firebaseManager.facebookLogout()
                    }
                }else
                {
                    self.showError(error.localizedDescription)

                }
            }
        
        })
    }
    
    @IBAction func facebookLogoutAction(sender: AnyObject) {
       // FBSDKLoginManager().logOut()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        FBSDKAccessToken.setCurrentAccessToken(nil)
        FBSDKProfile.setCurrentProfile(nil)
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
