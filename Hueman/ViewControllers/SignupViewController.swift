//
//  SignupViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var topHeightSpace: NSLayoutConstraint!
    
    var firebaseManager = FirebaseManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        nameField.placeholder = "John Doe"
        
        // Creating Tap Gesture to dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.dismissKeyboard(_:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        // Creating Swipe Gesture to dismiss Keyboard
        let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(SignupViewController.dismissKeyboard(_:)))
        swipDown.direction = .Down
        view.addGestureRecognizer(swipDown)
    }

    
    @IBAction func didTappedSignup(sender: AnyObject) {
        
        if AppSettings.DEBUG {
            self.performSegueWithIdentifier("CreateProfile", sender: sender)
            return
        }
        

        showWaitOverlay()
        
        if let email = self.emailField.text, let password = self.passwordField.text, let name = nameField.text
        {
            
            firebaseManager.signUp(email, password: password, name: name, completion: {
                
                    self.removeAllOverlays()

                self.performSegueWithIdentifier("CreateProfile", sender: sender)

                }, onerror: { errorMsg in
                    self.removeAllOverlays()
                    self.showError(errorMsg)
            
            })
                
        }else {
            showError("any of the fields can't be empty")
        }
        
    
    }

    
    @IBAction func didTappedCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    }

}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
     
        textField.resignFirstResponder()

        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = nil
    }
    
    // Moving the View down after the Keyboard disappears
    func textFieldDidEndEditing(textField: UITextField) {
        let convertedString = nameField.text
        nameField.text = convertedString?.capitalizedStringWithLocale(NSLocale.currentLocale())
    }
    
}
