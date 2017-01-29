//
//  CreateProfileViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/7/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftOverlays

class CreateProfileViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var bioTextfield: UITextView!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var birthdayImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tapToAddPhotoLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: ActivityIndicator!
    
    @IBOutlet var profilesHues: [ProfileHue]?
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var storageRef: FIRStorageReference! {
        return FIRStorage.storage().reference()
    }
    
    var hues: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidden = true
        saveButton.enabled = false
        
        self.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.clearColor();
        
        if !AppSettings.DEBUG {
            if let name = FIRAuth.auth()?.currentUser!.displayName  {
                nameTextfield.text = name
            }else {
                nameTextfield.attributedPlaceholder = NSAttributedString(string: "What's your name?", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
            }
        }
        nameTextfield.delegate = self
        nameTextfield.autocapitalizationType = .Words
        nameTextfield.attributedPlaceholder = NSAttributedString(string: "What's your name?", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        var topics: [String] = [Topic.Wanderlust, Topic.OnMyPlate, Topic.RelationshipMusing, Topic.Health, Topic.DailyHustle, Topic.RayOfLight]
        
        for (index, hue) in profilesHues!.enumerate() {
            hue.type = topics[index]
            let hueGesture = UITapGestureRecognizer(target: self, action: #selector(CreateProfileViewController.addHue(_:)))
            hue.addGestureRecognizer(hueGesture)
        }
        
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.borderColor = UIColor.UIColorFromRGB(0x999999).CGColor
        profileImage.contentMode = .ScaleAspectFill
        
        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.addGestureRecognizer(profileImageTapGesture)
        
        // Creating Tap Gesture to dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateProfileViewController.dismissKeyboard(_:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedLocation))
        locationTapGesture.numberOfTapsRequired = 1
        locationImage.addGestureRecognizer(locationTapGesture)
        
        bioTextfield.delegate = self
        
        
        let birthdayImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(birthdayImageTapped))
        birthdayImage.addGestureRecognizer(birthdayImageTapGesture)
        
        
        self.navigationBar.topItem!.title = "create profile"
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 18)!,NSForegroundColorAttributeName : UIColor.UIColorFromRGB(0xffffff)]
        
        hues = [
            Topic.Wanderlust: "",
            Topic.OnMyPlate: "",
            Topic.RelationshipMusing: "",
            Topic.Health: "",
            Topic.DailyHustle: "",
            Topic.RayOfLight: ""
        ]
        
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier  == "BirthdayEntry" {
            
            let birthdayController = segue.destinationViewController as! BirthdayController
            birthdayController.delegate = self
        }
        
        if segue.identifier  == "AddLocation" {
            
            let locationController = segue.destinationViewController as! AddLocationController
            locationController.delegate = self
        }
        
        if segue.identifier  == "AddHue" {
            if sender != nil {
                
                if let unwrappedType = sender {
                    let hueController = segue.destinationViewController as! AddHueController
                    hueController.delegate = self
                    hueController.type = unwrappedType as? String
                    
                }

            }
        }
        
    }


    @IBAction func cameraTapped(sender: AnyObject) {
        handleCamera()
    }
    

    @IBAction func didTappedSave(sender: AnyObject) {
        
        //showWaitOverlay()
        activityIndicator.show()

        
        let currentUser = FIRAuth.auth()?.currentUser
        
        
        let trimmedName = currentUser?.displayName!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

        let imageData = UIImageJPEGRepresentation(profileImage.image!, 0.4)

        let imagePath = "userProfileImage\(currentUser?.uid)/\(trimmedName).jpg"
        let imageRef = storageRef.child(imagePath)
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(imageData!, metadata: metadata, completion: {
            (metadata, error) in
            if error == nil {
                let changeRequest = currentUser?.profileChangeRequest()
                
                if let photoURL = metadata!.downloadURL(){
                    changeRequest!.photoURL = photoURL
                }
                
                changeRequest?.commitChangesWithCompletion({
                  error in
                    if error == nil {
                        
                        var updatedUser = User(email: (currentUser?.email!)!, name: (currentUser?.displayName)!, userId: currentUser!.uid)
                        
                        updatedUser.birthday = self.dateLabel.text
                        updatedUser.location = self.locationLabel.text
                        updatedUser.bio = self.bioTextfield.text
                        updatedUser.photoURL = changeRequest?.photoURL?.absoluteString
                        
                        let updateRef = self.dataBaseRef.child("/users/\(updatedUser.uid)")
                        updateRef.updateChildValues(updatedUser.toAnyObject())
                        
                    
                        
                        let huesRef = updateRef.child("hues")
                        huesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                            if snapshot.exists() {
                                huesRef.updateChildValues(self.hues)
                            }else {
                                huesRef.setValue(self.hues)
                            }
                        })
            
                        self.activityIndicator.hide()
                        
                        self.performSegueWithIdentifier("UserCreated", sender: sender)


                        
                    }else {
                        self.showError((error?.localizedDescription)!)
                    }
                })
            }
        })
        
    }
    
    
    @IBAction func nameTextFieldDidChanged(sender: AnyObject) {
        checkRequiredProfileInfos()
    }
    
    func remove() {
        self.willMoveToParentViewController(nil)
        self.didMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

    
    func profileImageTapped() {
        
        handleSelectedProfileImageView()
    }
    
    
    
    func birthdayImageTapped() {
        
        self.performSegueWithIdentifier("BirthdayEntry", sender: nil )
        
    }
    
    func addHue(sender: UITapGestureRecognizer) {
        let hue = (sender as UITapGestureRecognizer).view as? ProfileHue
        self.performSegueWithIdentifier("AddHue", sender: hue?.type )
        
        
    }
    
    func didTappedLocation() {
        self.performSegueWithIdentifier("AddLocation", sender: nil )
    }
    
    // Dismissing all editing actions when User Tap or Swipe down on the Main View
    func dismissKeyboard(gesture: UIGestureRecognizer){
        self.view.endEditing(true)
        
    }
    
    
    func checkRequiredProfileInfos() {
        
        if !(nameTextfield.text?.isEmpty)! && !bioTextfield.text.isEmpty && tapToAddPhotoLabel.hidden == true && locationLabel.text?.lowercaseString != "What city do you live in?".lowercaseString && dateLabel.text?.lowercaseString != "When’s your birthday?".lowercaseString {
            
            saveButton.enabled = true
        }else {
            saveButton.enabled = false
        }
        
        
    }
    
    

    
}


