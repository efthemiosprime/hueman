//
//  CreateProfileViewController+Handlers.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/7/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

extension CreateProfileViewController: UIImagePickerControllerDelegate {
    
    func handleSelectedProfileImageView() {

        let camera = Camera(delegate: self)
        camera.PresentPhotoLibrary(self, canEdit: true)
    }
    
    func handleCamera() {
        let camera = Camera(delegate: self)
        camera.PresentPhotoCamera(self, canEdit: true)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            selectedImageFromPicker = editedImage as? UIImage
            profileImageSet = true
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = originalImage as? UIImage
            profileImageSet = true
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
            tapToAddPhotoLabel.hidden = true
            profileImageSet = true
        }
        
        
   //     checkRequiredProfileInfos()
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}



extension CreateProfileViewController: UITextFieldDelegate {
    // Dismissing the Keyboard with the Return Keyboard Button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        nameTextfield.resignFirstResponder()
      //  checkRequiredProfileInfos()
        return true
    }
    
    // Moving the View up after the Keyboard appears
    func textFieldDidBeginEditing(textField: UITextField) {
        //animateView(true, moveValue: 80)
        if textField.placeholder != nil {
            textField.placeholder = nil;

        }

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



extension CreateProfileViewController: UITextViewDelegate {
    

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text.lowercaseString == "Write anything you’d like telling other Huemans who view your profile to see...".lowercaseString {
            textView.textColor = UIColor.whiteColor()
            textView.text = ""

        }
        return true
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.text?.capitalizeFirstLetter()

        return true
    }
    
    func textViewDidChange(textView: UITextView) {
       // checkRequiredProfileInfos()
    }
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            locationTextField.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    
    
}

extension CreateProfileViewController: BirthdayDelegate {
    func pickerDidChange(date: String) {
        dateLabel.text = date
        checkRequiredProfileInfos()
    }
}


extension CreateProfileViewController: LocationDelegate {
    func setLocation(location: String) {
        locationLabel.text = location
        checkRequiredProfileInfos()

    }
}


extension CreateProfileViewController: AddHueDelegate {
    func setHue(hue: String, type: String) {
        switch type {
            case Topic.Wanderlust:
                let data = ProfileHueModel(title: "I would love to visit", description: hue, type: Topic.Wanderlust)
                profilesHues![0].data = data
                self.hues[Topic.Wanderlust] = data.description
                break
                
            case Topic.OnMyPlate:
                let data = ProfileHueModel(title: "I love to stuff myself with", description: hue, type: Topic.OnMyPlate)
                profilesHues![1].data = data
                self.hues[Topic.OnMyPlate] = data.description

                break
                
            case Topic.RelationshipMusing:
                let data = ProfileHueModel(title: "I cherish my relationship with", description: hue, type: Topic.Wanderlust)
                profilesHues![2].data = data
                self.hues[Topic.RelationshipMusing] = data.description

                
                break
                
            case Topic.Health:
              let data = ProfileHueModel(title: "I keep health / fit by", description: hue, type: Topic.Health)
              profilesHues![3].data = data
              self.hues[Topic.Health] = data.description

                break
                
            case Topic.DailyHustle:
                let data = ProfileHueModel(title: "I am a", description: hue, type: Topic.DailyHustle)

                profilesHues![4].data = data
                self.hues[Topic.DailyHustle] = data.description

                break
                
                
                
            default:
                let data = ProfileHueModel(title: "What makes you smile?", description: hue, type: Topic.RayOfLight)

                profilesHues![5].data = data
                self.hues[Topic.RayOfLight] = data.description
                break
        }
    }
}


extension CreateProfileViewController: UIPopoverPresentationControllerDelegate {
    
    func showError(msg: String, srcView: UIView) {
        let errorController: ErrorController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("errorID") as? ErrorController)!
        errorController.preferredContentSize = CGSizeMake(300, 120)
        errorController.modalPresentationStyle = UIModalPresentationStyle.Popover
        errorController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        errorController.popoverPresentationController?.delegate = self
        errorController.popoverPresentationController?.sourceView = srcView
        errorController.popoverPresentationController?.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds),CGRectGetMidY(srcView.bounds),0,0)
        
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
