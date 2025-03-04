//
//  SignupController.swift
//  Hueman
//
//  Created by Efthemios Prime on 3/26/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var confirmPasswordInput: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var progressIndicator: UIView!
    @IBOutlet weak var activityIndicator: ActivityIndicator!
    
    var firebaseManager = FirebaseManager()

    let EMAIL_TEXT = "email"
    let PASSWORD_TEXT = "password"
    let CONFIRM_PASSWORD_TEXT = "confirm password"
    
    let EMAIL_PLACEHOLDER_TEXT = "example@domain.com"
    let PASSWORD_PLACEHOLDER_TEXT = "must have at least 6 characters"
    let CONFIRM_PASSWORD_PLACEHOLDER_TEXT = "confirm password"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableSignup()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignupController.doneEditing))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        emailInput.addTarget(self, action: #selector(SignupAddNameController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        passwordInput.addTarget(self, action: #selector(SignupAddNameController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        confirmPasswordInput.addTarget(self, action: #selector(SignupAddNameController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        progressIndicator.hidden = true
        emailLabel.text = ""
        passwordLabel.text = ""
        confirmPasswordLabel.text = ""
    }

    @IBAction func loginAction(sender: UIButton) {
        self.performSegueWithIdentifier("backToLogin", sender: self)

    }
    
    func textFieldDidChange(textField: UITextField) {
        if textField == emailInput {
            if textField.text?.characters.count == 0 {
                textField.placeholder = EMAIL_PLACEHOLDER_TEXT
                emailLabel.text = ""
                
            }else {
                emailLabel.text = EMAIL_TEXT
            }
        }
        
        if textField == passwordInput {

            if textField.text?.characters.count == 0 {
                textField.placeholder = PASSWORD_PLACEHOLDER_TEXT
                passwordLabel.text = ""
                
            }else {
                passwordLabel.text = PASSWORD_TEXT
            }
        }
        
        if textField == confirmPasswordInput {
            if textField.text?.characters.count == 0 {
                textField.placeholder = CONFIRM_PASSWORD_PLACEHOLDER_TEXT
                confirmPasswordLabel.text = ""
                
            }else {
                confirmPasswordLabel.text = CONFIRM_PASSWORD_TEXT
            }
        }
        
        if validateEmail(emailInput.text!) &&
        validatePassword(passwordInput.text!) &&
        passwordInput.text == confirmPasswordInput.text
        {
            enableSignup()
        }else {
            disableSignup()
        }
        
    }

    @IBAction func signupAction(sender: AnyObject) {
        showIndicator()
        if let email = self.emailInput.text, let password = self.passwordInput.text{
            
            firebaseManager.signUp(email, password: password, name: "", completion: {
                self.hideIndicator()
                if let authenticatedUser = FIRAuth.auth()?.currentUser {
                    SignupManager.sharedInstance.currentUser = User(email: authenticatedUser.email!, name: authenticatedUser.displayName!, userId: authenticatedUser.uid)
                }
                self.performSegueWithIdentifier("gotoAddName", sender: sender)

                
            }, onerror: { errorMsg in
                self.hideIndicator()
                self.showError(errorMsg)
            })
            
        }
    }
}


extension SignupController {
    func enableSignup() {
        signupButton.layer.borderWidth = 0
        signupButton.backgroundColor = UIColor.UIColorFromRGB(0x33b5d3)
        signupButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signupButton.enabled = true
    }
    
    func disableSignup() {
        signupButton.layer.borderWidth = 1
        signupButton.setTitleColor(UIColor(rgb: 0x33b5d3, alphaVal: 0.4), forState: .Normal)
        signupButton.layer.borderColor = UIColor(rgb: 0x33b5d3, alphaVal: 0.4).CGColor
        signupButton.backgroundColor = UIColor.clearColor()
        signupButton.enabled = false
    }
    
    func doneBtnToKeyboardToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace , target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(self.doneEditing))
        doneBtn.tintColor = UIColor.UIColorFromRGB(0x666666)
        
        if let font = UIFont(name: Font.SofiaProRegular, size: 15) {
            doneBtn.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        toolbar.setItems([spacer, doneBtn], animated: false)
        
        
    }
    
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(enteredEmail)
    }
    
    func validatePassword(enteredPassword:String) -> Bool {
        let passwordFormat = "[A-Z0-9a-z.!&^%$#@()/_*+-]{6,}$"
        let passPredicate = NSPredicate(format:"SELF MATCHES %@", passwordFormat)
        return passPredicate.evaluateWithObject(enteredPassword)
    }
    
    func showIndicator() {
        progressIndicator.hidden = false
        activityIndicator.show()
        
    }
    
    func hideIndicator() {
        progressIndicator.hidden = true
        activityIndicator.hide()
        
    }
    func doneEditing() {
        
        self.view.endEditing(true)

        emailInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
        confirmPasswordInput.resignFirstResponder()
    }
}

extension SignupController: UIPopoverPresentationControllerDelegate {
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
    }
}
