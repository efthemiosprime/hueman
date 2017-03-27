//
//  LoginController.swift
//  Hueman
//
//  Created by Efthemios Prime on 3/26/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var activityIndicatorContainer: UIView!
    @IBOutlet weak var activityIndicator: ActivityIndicator!
    
    let EMAIL_LABEL = "email"
    let PASSWORD_LABEL = "password"
    let EMAIL_PLACEHOLDER = "example@domain.com"
    let PASSWORD_PLACEHOLDER = "password"
    
    let firebaseManager = FirebaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailInput.addTarget(self, action: #selector(LoginController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        passwordInput.addTarget(self, action: #selector(LoginController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        // Creating Tap Gesture to dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignupAddNameController.doneEditing))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        if hasLogin {
            if let storedEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String, let storedPassword = firebaseManager.keychainWrapper.myObjectForKey("v_Data") as? String {
                emailInput.text = storedEmail
                passwordInput.text = storedPassword
            }
        }
        

        emailInput.delegate = self
        passwordInput.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicatorContainer.hidden = true

        emailLabel.text = ""
        passwordLabel.text = ""
    }

    func textFieldDidChange(textField: UITextField) {
        if textField == emailInput {
            if textField.text?.characters.count == 0 {
                textField.placeholder = EMAIL_PLACEHOLDER
                emailLabel.text = ""
                
            }else {
                emailLabel.text = EMAIL_LABEL
            }
        }
        

        
        if textField == passwordInput {
            if textField.text?.characters.count == 0 {
                textField.placeholder = PASSWORD_PLACEHOLDER
                passwordLabel.text = ""
                
            }else {
                passwordLabel.text = PASSWORD_LABEL
            }
        }
        

    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        
        if !isValidEmail(emailInput.text!) {
            self.showError("invalid email format")
            return
        }
        
//        let btn = sender as! UIButton
//        btn.enabled = false
        
        showIndicator()
        
        
        if let email = self.emailInput.text, let password = self.passwordInput.text {
            firebaseManager.logIn(email, password: password, loggedIn: {
                // AuthenticationManager.sharedInstance
                self.hideIndicator()
                
                
                self.performSegueWithIdentifier("LoginConfirmed", sender: sender)
                
                }, onerror: { errorMsg in
                    
                    self.hideIndicator()
                    self.showError(errorMsg)
            })
        }else {
            self.showError("email/password can't be empty")
            
        }
    }
    
    @IBAction func unwindAction(segue: UIStoryboardSegue) {}

}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


extension LoginController {
    
    func showIndicator() {
        activityIndicatorContainer.hidden = false
        activityIndicator.show()
        
    }
    
    func hideIndicator() {
        activityIndicatorContainer.hidden = true
        activityIndicator.hide()
        
    }
    
    func doneEditing() {
        
        self.view.endEditing(true)
        emailInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
        
    }
    
    func showError(msg: String) {
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
    
    

    
    
}


extension LoginController: UIPopoverPresentationControllerDelegate {
    // MARK: - Popover
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
