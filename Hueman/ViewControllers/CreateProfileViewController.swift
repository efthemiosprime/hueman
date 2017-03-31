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
    @IBOutlet weak var bioView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: ActivityIndicator!
    
    @IBOutlet var profilesHues: [ProfileHue]?
    
    var backItem: UIBarButtonItem!
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var storageRef: FIRStorageReference! {
        return FIRStorage.storage().reference()
    }
    
    enum Mode {
        case edit
        case create
    }
    
    var hues: [String: String] = [:]
    
    var profileImageSet = false
    
    var errorType: String = ""
    
    var scrollOffset: CGFloat = 0.0
    var keyboardHeight: CGFloat = 0.0
    var bioFrame: CGRect?
    
    var mode = Mode.create
    var viewModel = CreateProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator.hidden = true
       // saveButton.enabled = false
        scrollView.delegate = self
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
            hue.tag = index
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
        
        
        let birthdayImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedBirthday))
        birthdayImage.addGestureRecognizer(birthdayImageTapGesture)
        

        
        hues = [
            Topic.Wanderlust: "",
            Topic.OnMyPlate: "",
            Topic.RelationshipMusing: "",
            Topic.Health: "",
            Topic.DailyHustle: "",
            Topic.RayOfLight: ""
        ]
        
        
        addDoneBtnToKeyboard()

        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(CreateProfileViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        
                notificationCenter.addObserver(self, selector: #selector(CreateProfileViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        bioFrame = bioView.frame
        
        if mode == .edit {
            editMode()
            
        }
        
        if AuthenticationManager.sharedInstance.currentUser == nil {
            AuthenticationManager.sharedInstance.loadCurrentUser()
        }
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 20)!,NSForegroundColorAttributeName : UIColor.UIColorFromRGB(0x999999)]
        
        
        saveButton.tintColor = UIColor.UIColorFromRGB(0x999999)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.UIColorFromRGB(0x999999)
        
        self.navigationBar.topItem?.title = (mode == .edit) ? "edit profile" : "create profile"

        print(viewModel.updateUser())
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier  == "BirthdayEntry" {
            
//            let birthdayController = segue.destinationViewController as! BirthdayController
            
            if sender != nil {
                if let dob = sender as? String {
//                    birthdayController.entry = dob
                }
  
            }

//            birthdayController.delegate = self
        }
        
        if segue.identifier  == "AddLocation" {
            
            let locationController = segue.destinationViewController as! AddLocationController
            if sender != nil {
                if let entry = sender as? String {
                    locationController.entry = entry
                }
                
            }
            
            locationController.delegate = self
        }
        
//        if segue.identifier  == "AddHue" {
//            if sender != nil {
//                
//                if let unwrappedType = sender {
//                    let hueController = segue.destinationViewController as! AddHueController
//                    hueController.delegate = self
//                    hueController.type = unwrappedType as? String
//                    
//                }
//
//            }
//        }
        
        if segue.identifier  == "AddHue" {
            if sender != nil {
                
                if let unwrappedTag = sender {
                    let addPageHuesController = segue.destinationViewController as! AddHuesPageController
                    addPageHuesController.selectedHueIndex = unwrappedTag.integerValue
                    addPageHuesController.hueDelegate = self
                  //  hueController.delegate = self
                    //hueController.type = unwrappedType as? String
                    
                }
                
            }
        }
        
    }


    @IBAction func cameraTapped(sender: AnyObject) {
        handleCamera()
    }
    

    @IBAction func didTappedSave(sender: AnyObject) {
        
        //showWaitOverlay()
        
        if profileImageSet == false {
            self.showError("Please add your profile photo.", srcView: profileImage)
            return
        }
        
        
        if bioTextfield.text.isEmpty || bioTextfield.text == "Write anything you’d like telling other Huemans who view your profile to see..." {
            self.showError("Please enter your bio.", srcView: bioTextfield)
//            bioTextfield.layer.borderWidth = 1.0;
//            bioTextfield.layer.borderColor = UIColor.redColor().CGColor
            return
        }
        
        
        if locationLabel.text == "What city do you live in?" || locationLabel.text!.isEmpty {
            errorType = "location"
            self.showError("Please add your current location.", srcView: locationImage)
            return
        }
        
        
        if dateLabel.text == "When’s your birthday?" || dateLabel.text!.isEmpty {
            errorType = "dob"

            self.showError("Please enter your date of birth.", srcView: birthdayImage)
            return
        }
        
        if nameTextfield.text!.isEmpty {
            errorType = "name"
            self.showError("Please enter your date of birth.", srcView: nameTextfield)
            return
        }
        

        
        activityIndicator.show()


        
        let currentUser = FIRAuth.auth()?.currentUser
        
    
        let imageData = UIImageJPEGRepresentation(profileImage.image!, 0.4)
        

        var imagePath = ""
        if let name = currentUser?.displayName {
            let trimName = String(name.characters.map {$0 == " " ? "_" : $0})
            if let unwrappedUID = currentUser?.uid {
                imagePath = "userProfileImage/\(unwrappedUID)/\(trimName.lowercaseString).jpg"
            }
        }
        
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
                
                changeRequest!.displayName = (self.mode == .edit) ? self.nameTextfield.text : (currentUser?.displayName)!
                
                changeRequest?.commitChangesWithCompletion({
                  error in
                    if error == nil {
                        
                        
                        var updatedUser = User(email: (currentUser?.email!)!, name: (changeRequest?.displayName)!, userId: currentUser!.uid)
                        

                        updatedUser.birthday!.date = self.dateLabel.text
                        updatedUser.location!.location = self.locationLabel.text
                        updatedUser.bio = self.bioTextfield.text
                        updatedUser.photoURL = changeRequest?.photoURL?.absoluteString
                        
                        let updateRef = self.dataBaseRef.child("/users/\(updatedUser.uid)")
                        
                    
                        
                        let huesRef = updateRef.child("hues")
                        huesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                            if snapshot.exists() {
                                huesRef.updateChildValues(self.hues)
                            }else {
                                huesRef.setValue(self.hues)
                            }
                        })
                        
                        
                        updateRef.updateChildValues(updatedUser.toAnyObject())

                    

            
                        self.activityIndicator.hide()
                        
                        if self.mode == .edit {
                            self.dismissViewControllerAnimated(false, completion: nil)
                        }else {
                            
                           self.performSegueWithIdentifier("UserCreated", sender: sender)

                        }
                        


                        
                    }else {
                        self.showError((error?.localizedDescription)!, srcView: self.view)
                    }
                })
            }
        })

        
        
    }
    
    
    @IBAction func nameTextFieldDidChanged(sender: AnyObject) {
        checkRequiredProfileInfos()
    }
    
    func editMode() {
        
        
        profileImageSet = true
        
        if !(viewModel.user?.hues.isEmpty)! {
            hues = [
                Topic.Wanderlust: (viewModel.user?.hues[Topic.Wanderlust])!,
                Topic.OnMyPlate: (viewModel.user?.hues[Topic.OnMyPlate])!,
                Topic.RelationshipMusing: (viewModel.user?.hues[Topic.RelationshipMusing])!,
                Topic.Health: (viewModel.user?.hues[Topic.Health])!,
                Topic.DailyHustle: (viewModel.user?.hues[Topic.DailyHustle])!,
                Topic.RayOfLight: (viewModel.user?.hues[Topic.RayOfLight])!
            ]
        }

        
        backItem = UIBarButtonItem(image: UIImage(named: "back-bar-item"), style: .Plain, target: self, action: #selector(CreateProfileViewController.backActionHandler))
        
        self.navigationBar.topItem?.leftBarButtonItem = backItem
      //  self.navigationItem.leftBarButtonItem = backItem

        
        viewModel.getUserImage({
            img in
            self.profileImage.image = img
            self.tapToAddPhotoLabel.hidden = true
        })
        
        if let bioText = viewModel.user?.bio {
            bioTextfield.text = bioText
        }
        
        if let userBirthday = viewModel.user?.birthday {
            dateLabel.text = userBirthday.date
        }
        
        if let userLocation = viewModel.user?.location {
            locationLabel.text = userLocation.location
        }
        
        saveButton.image = UIImage(named: "topbar-save-valid-icon")
        
        viewModel.getUserHues(profilesHues!)
    }
    
    func backActionHandler() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    
    
    func didTappedBirthday() {
        
        if dateLabel.text != "When’s your birthday?" && !(dateLabel.text?.isEmpty)! {
            self.performSegueWithIdentifier("BirthdayEntry", sender: dateLabel.text )
        }else {
            self.performSegueWithIdentifier("BirthdayEntry", sender: nil )

        }
        
    }
    
    func addHue(sender: UITapGestureRecognizer) {
        let hue = (sender as UITapGestureRecognizer).view as? ProfileHue
        print("tage \(hue!.tag) ")
        self.performSegueWithIdentifier("AddHue", sender: hue?.tag )
        
        
    }
    
    func didTappedLocation() {
        
        if locationLabel.text != "What city do you live in?" && !(locationLabel.text?.isEmpty)! {
            self.performSegueWithIdentifier("AddLocation", sender: locationLabel.text )
        }else {
            self.performSegueWithIdentifier("AddLocation", sender: nil )
            
        }
        
    }
    
    // Dismissing all editing actions when User Tap or Swipe down on the Main View
    func dismissKeyboard(gesture: UIGestureRecognizer){
        
        
        bioTextfield.resignFirstResponder()

        self.view.endEditing(true)
        
    }
    

    
    func checkRequiredProfileInfos() {
        
        if !(nameTextfield.text?.isEmpty)! && !bioTextfield.text.isEmpty && tapToAddPhotoLabel.hidden == true && locationLabel.text?.lowercaseString != "What city do you live in?".lowercaseString && dateLabel.text?.lowercaseString != "When’s your birthday?".lowercaseString {
            
            saveButton.image = UIImage(named: "topbar-save-valid-icon")
        }else {
            saveButton.image = UIImage(named: "topbar-save-invalid-icon")
        }
        
        
    }
    
    
    func addDoneBtnToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace , target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(self.doneEditing))
        doneBtn.tintColor = UIColor.UIColorFromRGB(0x666666)
        
        if let font = UIFont(name: Font.SofiaProRegular, size: 15) {
            doneBtn.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        toolbar.setItems([spacer, doneBtn], animated: false)
        
        bioTextfield.inputAccessoryView = toolbar
        
    }
    
    
    func moveUI(uiView: UIView, distance: CGFloat, up: Bool) {
        
        if scrollOffset > 50.0 {
            return
        }
        let duration = 0.3
        
        
        UIView.beginAnimations("moveUI", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration)
        let distanceFactor = distance + scrollOffset
        
        let movement: CGFloat = CGFloat(up ? distanceFactor : -distanceFactor)
        
        if up {
            uiView.frame = CGRectOffset(uiView.frame, 0, movement)
            UIView.commitAnimations()
        }else {
            uiView.frame = bioFrame!
            UIView.commitAnimations()
        }


    }
    
    func doneEditing() {
        
        if bioTextfield.text.isEmpty {
            bioTextfield.text = "Write anything you’d like telling other Huemans who view your profile to see..."
            bioTextfield.textColor = UIColor.UIColorFromRGB(0xAAAAAA)
        }
        
        
        self.view.endEditing(true)
        bioTextfield.resignFirstResponder()


    }
    

    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height

    }
    
    func keyboardWillHide(notification: NSNotification) {

        moveUI(bioView, distance: -55, up: false)

        bioTextfield.resignFirstResponder()
        self.view.endEditing(true)

    }
    
}


