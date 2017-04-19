//
//  AddBioController.swift
//  Hueman
//
//  Created by Efthemios Prime on 4/2/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class AddBioController: UIViewController {

    @IBOutlet weak var nextButton: RoundedCornersButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bioInput: UITextView!
    
    @IBOutlet weak var bioInputConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var keyboardConstraintHeight: NSLayoutConstraint!
    
    let SKIP_LABEL = "maybe later"
    let NEXT_LABEL = "next"
    
    var isSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignupManager.sharedInstance.currentUser = AuthenticationManager.sharedInstance.currentUser

        bioInput.delegate = self
        buttonSkip()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if SignupManager.sharedInstance.currentUser != nil {
            if !(SignupManager.sharedInstance.currentUser?.bio?.isEmpty)! {
                bioInput.text = SignupManager.sharedInstance.currentUser?.bio
            }
        }
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.performSegueWithIdentifier("backToAddPhoto", sender: self)
    }

    @IBAction func nextAction(sender: AnyObject) {
        if bioInput.text == "write here..." &&  !bioInput.text.isEmpty {
            SignupManager.sharedInstance.currentUser?.bio = ""

        }else {
            SignupManager.sharedInstance.currentUser?.bio = bioInput.text

        }
        self.performSegueWithIdentifier("gotoAddHues", sender: self)
    }
    
    @IBAction func backToBio(segue: UIStoryboardSegue) {}
}


extension AddBioController: UITextViewDelegate {
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text == "write here..." {
            textView.text = ""
        }
        return true
    }
    
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        textField.text?.capitalizeFirstLetter()
        textField.resignFirstResponder()
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        
        if textView.text == "write here..." || textView.text.characters.count == 0{
            buttonSkip()
        }
        
        if textView.text.characters.count >= 5 && textView.text != "write here..."{
            buttonNext()
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        return textView.text.characters.count + (text.characters.count - range.length) <= 300
    }
}


extension AddBioController {
    func buttonNext() {
        nextButton.layer.borderWidth = 0
        nextButton.backgroundColor = UIColor.whiteColor()
        nextButton.setTitleColor(UIColor.UIColorFromRGB(0x666666), forState: .Normal)
        nextButton.setTitle(NEXT_LABEL, forState: .Normal)

    }
    
    func buttonSkip() {
        nextButton.layer.borderWidth = 1
        nextButton.setTitle(SKIP_LABEL, forState: .Normal)
        nextButton.setTitleColor(UIColor(rgb: 0xffffff, alphaVal: 0.4), forState: .Normal)
        nextButton.layer.borderColor = UIColor(rgb: 0xffffff, alphaVal: 0.4).CGColor
        nextButton.tintColor = UIColor.UIColorFromRGB(0xffffff)
        nextButton.backgroundColor = UIColor.clearColor()
    }
}
