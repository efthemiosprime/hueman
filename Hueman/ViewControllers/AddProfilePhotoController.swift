//
//  AddProfilePhotoController.swift
//  Hueman
//
//  Created by Efthemios Prime on 3/26/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

protocol AddProfilePhotoDelegate {
    func editPhoto(imageData: NSData?)
}


class AddProfilePhotoController: UIViewController, UINavigationControllerDelegate{

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var addEditButton: UIButton!
    @IBOutlet weak var profilePhotoContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    
    @IBOutlet weak var nextButton: RoundedCornersButton!
    
    var addIcon: UIImage?
    var deleteIcon: UIImage?
    var profilePhotoPlaceholder: UIImage?
    
    var profilePhotoIsSet = false
    
    let HEADER_LABEL = "Be ready to embrace\nlife’s awesomeness."
    let SUB_HEADER_LABEL = "But first, give us your best shot!"
    let HEADER_LABEL_SET = "Looking good!"
    
    var mode = Mode.add
    
    var delegate: AddProfilePhotoDelegate?
    
    var previousController:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        profilePhoto.clipsToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.frame.size.width / 2
        //        profileImage.layer.borderColor = UIColor.UIColorFromRGB(0x999999).CGColor
        profilePhoto.contentMode = .ScaleAspectFill
        
        profilePhotoContainer.layer.cornerRadius = profilePhotoContainer.frame.size.width / 2
        profilePhotoContainer.layer.borderWidth = 1
        profilePhotoContainer.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        addIcon = UIImage(named: "add-profile-photo-btn")
        deleteIcon = UIImage(named: "delete-profile-photo-btn")
        profilePhotoPlaceholder = UIImage(named: "profile-image-placeholder")
        enableNext()
//        let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
//        print(appDelegate.window!.subviews.count)

       // let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
        
        AuthenticationManager.sharedInstance.loadCurrentUser()
        SignupManager.sharedInstance.currentUser = AuthenticationManager.sharedInstance.currentUser
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if mode == .edit {
            backButton.hidden = false
            
            if let unwrappedPrevController = previousController {
                if unwrappedPrevController == "Profile" {
                    let profileController = self.delegate as? ProfileViewController
                    if profileController != nil {
                        if profileController?.profileImage.image != nil {
                            profilePhoto.image = profileController?.profileImage.image
                        }
                    }
                }
            }


        }else {
            backButton.hidden = true

        }
        
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
      //  self.performSegueWithIdentifier("backToBio", sender: self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func nextAction(sender: AnyObject) {
        
        if mode == Mode.edit {
            self.dismissViewControllerAnimated(true, completion: nil)

        } else {
            if profilePhotoIsSet {
                
                SignupManager.sharedInstance.userImageData = UIImageJPEGRepresentation(profilePhoto.image!, 0.1) as NSData?
            }
            self.performSegueWithIdentifier("gotoAddBio", sender: self)
        }

    }

    @IBAction func backToAddPhoto(segue: UIStoryboardSegue) {}

}


extension AddProfilePhotoController: UIImagePickerControllerDelegate {
    
    func handlePhotoLibrary() {
        previousController = ""
        let camera = Camera(delegate: self)
        camera.PresentPhotoLibrary(self, canEdit: true)
    }
    
    func handleCamera() {
        previousController = ""

        let camera = Camera(delegate: self)
        camera.PresentPhotoCamera(self, canEdit: true)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            selectedImageFromPicker = editedImage as? UIImage
            profilePhotoIsSet = true
            
            if mode == Mode.edit {
                let imageData: NSData = UIImagePNGRepresentation(editedImage as! UIImage)!
                self.delegate?.editPhoto(imageData)
            }
            
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = originalImage as? UIImage
            profilePhotoIsSet = true
            
            if mode == Mode.edit {
                let imageData: NSData = UIImagePNGRepresentation(originalImage as! UIImage)!
                self.delegate?.editPhoto(imageData)
            }
            
        }
        
        if let selectedImage = selectedImageFromPicker {
            profilePhoto.image = selectedImage
            profilePhotoIsSet = true
            addEditButton.setImage(deleteIcon, forState: .Normal)
            headerLabel.text = HEADER_LABEL_SET
            subHeaderLabel.text = ""
            enableNext()
            
            if mode == Mode.edit {
                let imageData: NSData = UIImagePNGRepresentation(selectedImage)!
                self.delegate?.editPhoto(imageData)
            }
        }
        
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension AddProfilePhotoController {
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
