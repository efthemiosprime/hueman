//
//  AddBioController.swift
//  Hueman
//
//  Created by Efthemios Prime on 4/2/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit
protocol AddBioDelegate {
    func didEditBio(bio:String)
}
class AddBioController: UIViewController {

    @IBOutlet weak var nextButton: RoundedCornersButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bioInput: UITextView!
    
    @IBOutlet weak var bioInputConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var keyboardConstraintHeight: NSLayoutConstraint!
    
    let SKIP_LABEL = "maybe later"
    let NEXT_LABEL = "next"
    
    var isSet = false
    
    var mode = Mode.add
    
    var delegate:AddBioDelegate?
    
    var previousController:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        bioInput.delegate = self
        buttonSkip()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        
        if mode == .edit {
            let profileController = self.delegate as? ProfileViewController
            if profileController?.bioLabel.text?.characters.count > 0 {
                bioInput.text = profileController?.bioLabel.text
                buttonNext()
            }
            
        }else {
            if SignupManager.sharedInstance.currentUser != nil {
                if !(SignupManager.sharedInstance.currentUser?.bio?.isEmpty)! {
                    bioInput.text = SignupManager.sharedInstance.currentUser?.bio
                }
            }
        }
    }
    
    @IBAction func backAction(sender: AnyObject) {
        if mode == .edit {
            self.delegate?.didEditBio(bioInput.text)

            self.dismissViewControllerAnimated(true, completion: nil)
        }else {
            self.performSegueWithIdentifier("backToAddPhoto", sender: self)
            
        }
        
    }

    @IBAction func nextAction(sender: AnyObject) {
        
        if mode == .edit {
            self.delegate?.didEditBio(bioInput.text)
            self.dismissViewControllerAnimated(true, completion: nil)
        }else {
            if bioInput.text == "Write here..." &&  !bioInput.text.isEmpty {
                SignupManager.sharedInstance.currentUser?.bio = ""
                
            }else {
                SignupManager.sharedInstance.currentUser?.bio = bioInput.text
                
            }
            self.performSegueWithIdentifier("gotoAddHues", sender: self)
        }
        

    }
    
    @IBAction func backToBio(segue: UIStoryboardSegue) {}
}


extension AddBioController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text == "Write here..." {
            textView.text = ""
        }
        return true
    }
    
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        textField.text?.capitalizeFirstLetter()
        textField.resignFirstResponder()
        
        return false
    }
    
    func textViewDidChange(textView: UITextView) {
        
        if textView.text == "Write here..." || textView.text.characters.count == 0{
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
        nextButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        //nextButton.enabled = false
        nextButton.setTitle(SKIP_LABEL, forState: .Normal)
        nextButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        nextButton.backgroundColor = UIColor.clearColor()
        nextButton.tintColor = UIColor.whiteColor()

    }
}
