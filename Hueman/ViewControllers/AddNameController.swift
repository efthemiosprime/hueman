//
//  AddNameController.swift
//  Hueman
//
//  Created by Efthemios Prime on 3/26/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class AddNameController: UIViewController {

    @IBOutlet weak var firstnameInput: UITextField!
    @IBOutlet weak var lastnameInput: UITextField!
    
    @IBOutlet weak var firstnameLine: UIView!
    @IBOutlet weak var lastnameLine: UIView!
    
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    
    @IBOutlet weak var nextButton: RoundedCornersButton!
    let FIRSTNAME_TEXT = "first name"
    let LASTNAME_TEXT = "last name"
    let FISTNAME_PLACEHOLDER_TEXT = "enter your first name"
    let LASTNAME_PLACEHOLDER_TEXT = "enter your last name"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstnameInput.delegate = self
        lastnameInput.delegate = self

        firstnameInput.addTarget(self, action: #selector(AddNameController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        lastnameInput.addTarget(self, action: #selector(AddNameController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        // Creating Tap Gesture to dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddNameController.doneEditing))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        firstnameInput.delegate = self
        lastnameInput.delegate = self
        ControllersStackManager.sharedInstance.controllers.append(self)

        print(ControllersStackManager.sharedInstance.controllers.count)


    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if firstnameInput.text?.characters.count == 0 {
            firstnameInput.placeholder = FISTNAME_PLACEHOLDER_TEXT
            firstnameLabel.text = ""
            firstnameLine.backgroundColor = UIColor.whiteColor()
            
        }else {
            firstnameLabel.text = FIRSTNAME_TEXT
        }
        
        
        if lastnameInput.text?.characters.count == 0 {
            lastnameInput.placeholder = LASTNAME_PLACEHOLDER_TEXT
            lastnameLabel.text = ""
            lastnameLine.backgroundColor = UIColor.whiteColor()
            
        }else {
            lastnameLabel.text = LASTNAME_TEXT
            
        }
        
        if lastnameInput.text?.characters.count > 2 && firstnameInput.text?.characters.count > 2 {
            enableNext()
        }else {
            disableNext()
        }
        

        
    }
    
    
    @IBAction func nextAction(sender: AnyObject) {
        let trimmedFirstNameString = firstnameInput.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        let trimmedLastNameString = lastnameInput.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        SignupManager.sharedInstance.currentUser?.name = "\(trimmedFirstNameString) \(trimmedLastNameString)"

        
        self.performSegueWithIdentifier("gotoAddPhoto", sender: self)

    }

    func textFieldDidChange(textField: UITextField) {
        if textField == firstnameInput {
            lastnameInput.resignFirstResponder()

            
            if textField.text?.characters.count == 0 {
                textField.placeholder = FISTNAME_PLACEHOLDER_TEXT
                firstnameLabel.text = ""
                firstnameLine.backgroundColor = UIColor.whiteColor()

            }else {
                firstnameLabel.text = FIRSTNAME_TEXT
            }
        }
        
        if textField == lastnameInput {
            firstnameInput.resignFirstResponder()

            if textField.text?.characters.count == 0 {
                textField.placeholder = LASTNAME_PLACEHOLDER_TEXT
                lastnameLabel.text = ""
                lastnameLine.backgroundColor = UIColor.whiteColor()
                
            }else {
                lastnameLabel.text = LASTNAME_TEXT
            }
        }
    

        if isValidInput(firstnameInput.text!) &&
            isValidInput(lastnameInput.text!)  {
            enableNext()
        }else {
            disableNext()
        }
    }
    
    func isValidInput(Input:String) -> Bool {
        let RegEx = "\\A\\w{2,30}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluateWithObject(Input)
    }
    
    @IBAction func backToAddName(segue: UIStoryboardSegue) {}

}


extension AddNameController {
    
    func disableNext() {
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.5).CGColor
        nextButton.backgroundColor = UIColor.clearColor()
        nextButton.tintColor = UIColor.whiteColor()
        nextButton.enabled = false
    }
    
    func enableNext() {
        nextButton.layer.borderWidth = 0
        nextButton.layer.borderColor = UIColor.whiteColor().CGColor
        nextButton.backgroundColor = UIColor.whiteColor()
        nextButton.tintColor = UIColor.UIColorFromRGB(0xe2573b)
        nextButton.enabled = true

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
        
        firstnameInput.inputAccessoryView = toolbar
        lastnameInput.inputAccessoryView = toolbar

    }
    
    func doneEditing() {
        
        self.view.endEditing(true)
        firstnameInput.resignFirstResponder()
        lastnameInput.resignFirstResponder()

    }
}

extension AddNameController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) { }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        let convertedString = textField.text
        textField.text = convertedString?.capitalizedStringWithLocale(NSLocale.currentLocale())
        
    }
}
