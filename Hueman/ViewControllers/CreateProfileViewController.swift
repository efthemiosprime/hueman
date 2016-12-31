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
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var cityInputView: UIView!
    @IBOutlet weak var backScrollView: UIView!
    @IBOutlet weak var locationInput: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    @IBOutlet var profilesHues: [ProfileHue]?
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var storageRef: FIRStorageReference! {
        return FIRStorage.storage().reference()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !AppSettings.DEBUG {
            if let name = FIRAuth.auth()?.currentUser!.displayName  {
                nameTextfield.text = name
            }
        }

        
        var topics: [String] = [Topic.Wanderlust, Topic.OnMyPlate, Topic.RelationshipMusing, Topic.Health, Topic.DailyHustle, Topic.RayOfLight]
        
        for (index, hue) in profilesHues!.enumerate() {
            hue.type = topics[index]
        }
        
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 132.5
        profileImage.layer.borderColor = UIColor.UIColorFromRGB(0x999999).CGColor
        profileImage.contentMode = .ScaleAspectFill
        
//        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
//        profileImage.addGestureRecognizer(profileImageTapGesture)
//        
//        // Creating Tap Gesture to dismiss Keyboard
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateProfileViewController.dismissKeyboard(_:)))
//        tapGesture.numberOfTapsRequired = 1
//        view.addGestureRecognizer(tapGesture)
//        
////        let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateProfileViewController.didTappedLocation(_:)))
////        locationTapGesture.numberOfTapsRequired = 1
////        locationImage.addGestureRecognizer(locationTapGesture)
//        
//        bioTextfield.delegate = self
//        
//        
//        let birthdayImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(birthdayImageTapped))
//        birthdayImage.addGestureRecognizer(birthdayImageTapGesture)
//        
//       
//        
        
        self.navigationBar.topItem!.title = "create profile"
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 18)!,NSForegroundColorAttributeName : UIColor.UIColorFromRGB(0xffffff)]
        
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier  == "BirthdayEntry" {
            
            let birthdayController = segue.destinationViewController as! BirthdayController
            birthdayController.delegate = self
        }
    }

    func profileImageTapped() {
        
        cityInputView.hidden = true
        handleSelectedProfileImageView()
    }
    
    @IBAction func cameraTapped(sender: AnyObject) {
        handleCamera()
    }
    
    
    func birthdayImageTapped() {

        self.performSegueWithIdentifier("BirthdayEntry", sender: nil )

    }
    
    func handleBirthdayPicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        dateLabel.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func didTappedLocation(gesture: UIGestureRecognizer) {
        self.view.endEditing(true)
        if cityInputView.hidden == true {
            cityInputView.hidden = false
        }
    }
    
    // Dismissing all editing actions when User Tap or Swipe down on the Main View
    func dismissKeyboard(gesture: UIGestureRecognizer){
        self.view.endEditing(true)

        if cityInputView.hidden == false {
            cityInputView.hidden = true
        }
        
    }
    @IBAction func locationInputDidChanged(sender: AnyObject) {
        locationInput.text = locationField.text
    }

    
    @IBAction func didTappedSave(sender: AnyObject) {
        
        showWaitOverlay()

        
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
                        updatedUser.location = self.locationInput.text
                        updatedUser.bio = self.bioTextfield.text
                        updatedUser.photoURL = changeRequest?.photoURL?.absoluteString
                        
                        
                        
                        let updateRef = self.dataBaseRef.child("/users/\(updatedUser.uid)")
                        updateRef.updateChildValues(updatedUser.toAnyObject())
                        
                        self.removeAllOverlays()
                        self.performSegueWithIdentifier("UserCreated", sender: sender)

                        
                    }
                })
            }
        })
        
 
        
    }

    
}


