//
//  ResetController.swift
//  Hueman
//
//  Created by Efthemios Prime on 5/17/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ResetController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailInputView: UIView!
    @IBOutlet weak var resetButton: RoundedCornersButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailInput.addTarget(self, action: #selector(ResetController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)        // Do any additional setup after loading the view.
        messageLabel.hidden = true
        disableReset()
    }

    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    
    
    func textFieldDidChange(textField: UITextField) {
        if textField == emailInput {
            if textField.text?.characters.count == 0 {
                textField.placeholder = "email"
                emailLabel.text = ""
                
            }else {
                emailLabel.text = "email"
            }
        }
        
        if isValidEmail(emailInput.text!) {
            enableReset()
        }
        
    
        
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func resetAction(sender: AnyObject) {
        resetButton.enabled = false
        FIRAuth.auth()?.sendPasswordResetWithEmail(emailInput.text!, completion: { error in
            if error == nil {
                self.emailInputView.hidden = true
                self.resetButton.hidden = true
                self.messageLabel.hidden = false
                self.messageLabel.text = "Instructions to reset password have been sent to your e-mail address."
            }else {
                print(error?.localizedDescription)
            }
        } )
    }

    
    func disableReset() {

        resetButton.setTitleColor(UIColor.UIColorFromRGB(0x666666), forState: UIControlState.Normal)
        resetButton.layer.borderWidth = 1
        // resetButton = UIColor.whiteColor().CGColor
        resetButton.layer.borderColor = UIColor.UIColorFromRGB(0x666666).CGColor
        
        resetButton.backgroundColor = UIColor.clearColor()
        resetButton.enabled = false
    }
    
    func enableReset() {

        
        resetButton.layer.borderWidth = 0
        resetButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        resetButton.backgroundColor = UIColor.UIColorFromRGB(0x666666)
        resetButton.enabled = true
        
    }
}
