//
//  SignupAddProfilePhotoController.swift
//  Hueman
//
//  Created by Efthemios Prime on 3/26/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class SignupAddProfilePhotoController: UIViewController, UINavigationControllerDelegate{

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var addEditButton: UIButton!
    @IBOutlet weak var profilePhotoContainer: RoundedCornersView!
    @IBOutlet weak var nextButton: RoundedCornersButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    
    var addIcon: UIImage?
    var deleteIcon: UIImage?
    var profilePhotoPlaceholder: UIImage?
    
    var profilePhotoIsSet = false
    
    let HEADER_LABEL = "Be ready to embrace\nlife’s awesomeness."
    let SUB_HEADER_LABEL = "But first, give us your best shot!"
    let HEADER_LABEL_SET = "Looking good!"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addIcon = UIImage(named: "add-profile-photo-btn")
        deleteIcon = UIImage(named: "delete-profile-photo-btn")
        profilePhotoPlaceholder = UIImage(named: "profile-image-placeholder")
        enableNext()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
       disableNext()
        enableNext()
        profilePhotoContainer.layer.borderWidth = 1
        profilePhotoContainer.layer.borderColor = UIColor.whiteColor().CGColor
    }

    
    @IBAction func addProfilePhotoAction(sender: AnyObject) {
        
        if profilePhotoIsSet {
            profilePhoto.image = profilePhotoPlaceholder
            profilePhotoIsSet = false
            addEditButton.setImage(addIcon, forState: .Normal)
            headerLabel.text = HEADER_LABEL
            subHeaderLabel.text = SUB_HEADER_LABEL
            disableNext()
        }else {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.handleCamera()
            }))
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
                self.handlePhotoLibrary()
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }


    }
    
    

    @IBAction func backAction(sender: AnyObject) {
        self.performSegueWithIdentifier("backToAddName", sender: self)
    }

    @IBAction func backToAddPhoto(segue: UIStoryboardSegue) {}

}


extension SignupAddProfilePhotoController: UIImagePickerControllerDelegate {
    
    func handlePhotoLibrary() {
        
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
            profilePhotoIsSet = true
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = originalImage as? UIImage
            profilePhotoIsSet = true
        }
        
        if let selectedImage = selectedImageFromPicker {
            profilePhoto.image = selectedImage
            profilePhotoIsSet = true
            addEditButton.setImage(deleteIcon, forState: .Normal)
            headerLabel.text = HEADER_LABEL_SET
            subHeaderLabel.text = ""
            enableNext()
            SignupManager.sharedInstance.userImageData = UIImagePNGRepresentation(selectedImage)! as NSData?
        }
        
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension SignupAddProfilePhotoController {
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
        nextButton.tintColor = UIColor.UIColorFromRGB(0x93648d)
        nextButton.enabled = true
        
    }
}
