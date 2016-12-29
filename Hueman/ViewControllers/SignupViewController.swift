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
    @IBOutlet weak var topHeightSpace: NSLayoutConstraint!
    
    var firebaseManager = FirebaseManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self

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
        
        if let email = self.emailField.text, let password = self.passwordField.text, let name = nameField.text
        {
                
            firebaseManager.signUp(email, password: password, name: name, completion: {
                    
                    self.performSegueWithIdentifier("CreateProfile", sender: sender)
                    
            })
                
        }else {
            print("any of the fields can't be empty")
        }
            
    
    }


    
    // Dismissing all editing actions when User Tap or Swipe down on the Main View
    func dismissKeyboard(gesture: UIGestureRecognizer){
        self.view.endEditing(true)
    }

}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
