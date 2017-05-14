//
//  ProfileViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/12/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftOverlays

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet var hues: [ProfileHue]?
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var profileBorder: UIView!
    @IBOutlet weak var birthdayPlusIcon: UIImageView!
    @IBOutlet weak var locationPlusIcon: UIImageView!
    @IBOutlet weak var birthdayEditIcon: UIImageView!
    @IBOutlet weak var locationEditIcon: UIImageView!
    @IBOutlet weak var bioEditIcon: UIImageView!
    @IBOutlet weak var photoEditLabel: UILabel!

    @IBOutlet weak var location: UIView!
    @IBOutlet weak var birthday: UIView!
    
    var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!
    var editedHues: [String: String]?
    var user: User?
    
    let cachedProfileImage = NSCache()
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    var editedImageData: NSData?
    var editedLocation: UserLocation?
    var editedBirthday: UserBirthday?
    var editedBio: String = ""
    
    var editMode = false
    var defaults = NSUserDefaults.standardUserDefaults()
    var signupManager = SignupManager.sharedInstance
    var autManager: AuthenticationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton =  UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(self.doneActionHandler))
        editButton =  UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(self.editActionHandler))
        addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.addActionHandler))
        //self.navigationBar.topItem?.rightBarButtonItem = editButton
        doneButton.tintColor = UIColor.UIColorFromRGB(0x999999)
        addButton.tintColor = UIColor.UIColorFromRGB(0x999999)
        editButton.tintColor = UIColor.UIColorFromRGB(0x999999)

        
        birthdayPlusIcon.image = UIImage(named: "create-plus-icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        birthdayPlusIcon.tintColor = UIColor.UIColorFromRGB(0x666666)
        locationPlusIcon.image = UIImage(named: "create-plus-icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        locationPlusIcon.tintColor = UIColor.UIColorFromRGB(0x666666)

        bioEditIcon.hidden = true
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2

        profileImage.contentMode = .ScaleAspectFill

        profileBorder.layer.cornerRadius = profileBorder.frame.size.width / 2
        profileBorder.layer.borderWidth = 1
        profileBorder.layer.borderColor = UIColor.UIColorFromRGB(0x999999).CGColor
        
        
        var topics: [String] = [Topic.Wanderlust, Topic.OnMyPlate, Topic.RelationshipMusing, Topic.Health, Topic.DailyHustle, Topic.RayOfLight]
        for (index, hue) in hues!.enumerate() {
            hue.type = topics[index]
        }
        
        addEditGestures()

        done()
        
        self.view.layer.masksToBounds = false
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        self.view.layer.shadowOpacity = 0.5
        
        editedHues = [
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
        
         autManager =  AuthenticationManager.sharedInstance

        
        if let authUid = autManager!.currentUser?.uid, let userUid = user?.uid {
            if authUid == userUid {
                self.navigationBar.topItem?.rightBarButtonItem = editButton

            }else {
                self.navigationBar.topItem?.rightBarButtonItem = nil
                self.navigationBar.topItem?.rightBarButtonItem = addButton

            }
        }

    
        if (locationLabel.text?.characters.count)! == 0 || (locationLabel.text?.isEmpty)! {
            locationPlusIcon.hidden = true
        }else {
            locationPlusIcon.hidden = false

        }
        
        if (birthdayLabel.text?.characters.count)! == 0 || (birthdayLabel.text?.isEmpty)! {
            birthdayPlusIcon.hidden = true
        }else {
            birthdayPlusIcon.hidden = false
        }
        

        
        if editMode {
            if (locationLabel.text?.characters.count)! > 0 || !(locationLabel.text?.isEmpty)! {
                locationEditIcon.hidden = true
                birthdayEditIcon.hidden = true
            }

            
            let userRef = dataBaseRef.child("users").queryOrderedByChild("email").queryEqualToValue(AuthenticationManager.sharedInstance.currentUser?.email!)
            userRef.observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                if snapshot.exists() {
                    let uid = self.user?.uid!
                    let userInfo = snapshot.value![uid!]!
                    self.user?.name = userInfo!["name"] as? String ?? ""
                    self.user?.bio =  userInfo!["bio"] as? String ?? ""
                    if let birthday = userInfo!["birthday"] as? UserBirthday {
                        self.user?.birthday = birthday
                    }
                    if let location = userInfo!["birthday"] as? UserLocation {
                        self.user?.location = location
                    }
   
                    
                    if let unwrappedUser = self.user {
                
                        self.getCurrentProfile(unwrappedUser)
                        self.signupManager.currentUser = unwrappedUser
                    }
                }
                
                
            })

            edit()
            
        }else {
            if let unwrappedUser = user {
                getCurrentProfile(unwrappedUser)
                signupManager.currentUser = unwrappedUser

            }
            //done()
        }
        
    

        
        self.navigationBar.topItem?.title = user!.name

        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 20)!,
            NSForegroundColorAttributeName : UIColor.UIColorFromRGB(0x999999)
        ]
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight)
            
            
        }) { (Finished) -> Void in
            
        }
        
        


    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        
        if segue.identifier  == "EditHue" {
            if sender != nil {
                if let unwrappedHue = sender as? ProfileHue {
                    let addHueController = segue.destinationViewController as! AddHueController
                    addHueController.delegate = self
                    addHueController.type = unwrappedHue.type
                    addHueController.mode = Mode.edit
                    addHueController.prev = "Profile"

                    if let type = unwrappedHue.type  {
                        if let data = unwrappedHue.data {
                            self.defaults.setObject(data.description, forKey: type)
                        }
                    }
                }
            }
        }
        
        if segue.identifier  == "EditBirthday" {
            let birthdayController = segue.destinationViewController as! AddBirthdayController
            birthdayController.delegate = self
            birthdayController.previousController = "Profile"
            birthdayController.mode = Mode.edit
            
        }
        
        if segue.identifier  == "EditLocation" {
            let locationController = segue.destinationViewController as! AddLocationController
            locationController.previousController = "Profile"
            locationController.delegate = self
            locationController.mode = Mode.edit
        
        }
        
        if segue.identifier  == "EditBio" {
            let bioController = segue.destinationViewController as! AddBioController
            bioController.mode = Mode.edit
            bioController.delegate = self
            bioController.previousController = "Profile"

        }
        
        
        
        if segue.identifier  == "EditProfileImage" {
            let photoController = segue.destinationViewController as! AddProfilePhotoController
            photoController.delegate = self
            photoController.previousController = "Profile"
            photoController.mode = Mode.edit
            
        }
    }
    


    @IBAction func backActionHandler(sender: AnyObject) {
        
        
        if editMode == true {
            return
        }
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame = CGRectOffset(self.view.frame, screenWidth, 0.0)
            
        }) { (Finished) -> Void in
        
            self.remove()
        }

    }
    @IBAction func backToProfile(segue: UIStoryboardSegue) {}

    
    
    // MARK - DONE ACTION
    func doneActionHandler() {
        done()
        
        if let unwrappedHues = hues {
            for hue in unwrappedHues {
                if let unwrappedData = hue.data {
                    if let type = hue.type, let detail = unwrappedData.description {
                        if detail.isEmpty {
                            signupManager.currentUser?.hues[type] = ""
                        }else {
                            signupManager.currentUser?.hues[type] = detail

                        }
                    }
                }

            }
        }
        
        if let unwrappedEditedLocation = editedLocation {
            signupManager.userLocation = unwrappedEditedLocation
            signupManager.currentUser?.location = signupManager.userLocation
        }else {
            if let unwrappedUserLocation = autManager?.currentUser?.location {
                signupManager.userLocation = unwrappedUserLocation
            }else {
                signupManager.userLocation = UserLocation(location: "")

            }
        }
        
        if let unwrappedEditedBirthday = editedBirthday {
            signupManager.userBirthday = unwrappedEditedBirthday
            signupManager.currentUser?.birthday = signupManager.userBirthday
        }else {
            if let unwrappedUserBirthday = autManager?.currentUser?.birthday {
                signupManager.currentUser?.birthday = unwrappedUserBirthday
            }else {
                signupManager.currentUser?.birthday = UserBirthday(date: "")
            }
        }
        
        if let unwrappedProfileImage = editedImageData {
            signupManager.userImageData = unwrappedProfileImage
        }else {
            signupManager.userImageData = UIImageJPEGRepresentation(profileImage.image!, 0.2)
        }
        
        if editedBio.characters.count > 0 || !editedBio.isEmpty {
            signupManager.currentUser?.bio = editedBio
        }else {
            if let bio = user?.bio {
                if bio.isEmpty {
                    signupManager.currentUser?.bio = ""
                }else {
                    signupManager.currentUser?.bio = bio
                }
            }else {
                signupManager.currentUser?.bio = ""

            }
        }

        if signupManager.currentUser != nil {
            self.signupManager.editProfile({
                
                AuthenticationManager.sharedInstance.loadCurrentUser({
                    self.user = self.signupManager.currentUser
                    self.editedHues = [
                        Topic.Wanderlust: "",
                        Topic.OnMyPlate: "",
                        Topic.RelationshipMusing: "",
                        Topic.Health: "",
                        Topic.DailyHustle: "",
                        Topic.RayOfLight: ""
                    ]
                    
                    self.editedImageData = nil
                    self.editedLocation = nil
                    self.editedBirthday = nil
                    self.editedBio = ""
                    
                    self.defaults.removeObjectForKey(Topic.Wanderlust)
                    self.defaults.removeObjectForKey(Topic.OnMyPlate)
                    self.defaults.removeObjectForKey(Topic.Health)
                    self.defaults.removeObjectForKey(Topic.RelationshipMusing)
                    
                    self.defaults.removeObjectForKey(Topic.DailyHustle)
                    self.defaults.removeObjectForKey(Topic.RayOfLight)
                    
                    self.signupManager.cleanup()
                })

                
            })

        }

    }
    
    func addActionHandler() {
        
    }
    func editActionHandler() {
        //self.performSegueWithIdentifier("EditProfile", sender: nil)
        edit()
    }
    
    func remove() {
        self.willMoveToParentViewController(nil)
        self.didMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

    func getCurrentProfile(_user: User) {
       // self.navigationBar.topItem!.title = _user.name
        var authenticatedUser: User?
        AuthenticationManager.sharedInstance.loadCurrentUser({
            authenticatedUser = AuthenticationManager.sharedInstance.currentUser
            self.signupManager.currentUser = authenticatedUser!
        })

        
        if let unwrappedEditedBirthday = editedBirthday {
            self.birthdayLabel.text = unwrappedEditedBirthday.date
            signupManager.currentUser?.birthday = unwrappedEditedBirthday
            
        }else {
            if let date = _user.birthday?.date {
                self.birthdayLabel.text = date
                if let unwrappedBirthday = authenticatedUser?.birthday {
                    signupManager.currentUser?.birthday = unwrappedBirthday
                }else {
                    signupManager.currentUser?.birthday = UserBirthday(date: "")
                }
            }
        }
        

        if let unwrappedEditedLocation = editedLocation {
            self.locationLabel.text = unwrappedEditedLocation.location
            signupManager.currentUser?.location = unwrappedEditedLocation

        }else {
            if let location = _user.location?.location {
                self.locationLabel.text = location
                if let unwrappedLocation = authenticatedUser?.location {
                    signupManager.currentUser?.location = unwrappedLocation
                }else {
                    signupManager.currentUser?.location = UserLocation(location: "")
                }
            }
        }
        
        if !editedBio.isEmpty || editedBio.characters.count > 0 {
            self.bioLabel.text = editedBio
            signupManager.currentUser?.bio = editedBio
        }else {
            self.bioLabel.text = _user.bio
            if let unwrappedBio = authenticatedUser?.bio {
                signupManager.currentUser?.bio = unwrappedBio
            }else {
                signupManager.currentUser?.bio = ""
            }

        }
        
        // edit mode
        if let unwrappedImageData = editedImageData {
            profileImage.image = UIImage(data: unwrappedImageData)
            signupManager.userImageData = unwrappedImageData
            if let unwrappedPhotoURL = _user.photoURL where !(_user.photoURL?.isEmpty)! {
                self.cachedProfileImage.removeObjectForKey(unwrappedPhotoURL)

            }
        }else {
            if let unwrappedPhotoURL = _user.photoURL where !(_user.photoURL?.isEmpty)! {
                
                if let cachedImage = self.cachedProfileImage.objectForKey(unwrappedPhotoURL) {
                    self.profileImage.image = cachedImage as? UIImage
                    signupManager.userImageData = UIImageJPEGRepresentation(cachedImage as! UIImage, 0.2)

                }else {
                    storageRef.referenceForURL(unwrappedPhotoURL).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                        if error == nil {
                            if let imageData = data {
                                let image = UIImage(data: imageData)
                                self.cachedProfileImage.setObject(image!, forKey: unwrappedPhotoURL)
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.profileImage.image = image
                                    
                                })
                            }
                        }else {
                            print(error!.localizedDescription)
                        }
                    })
                }
            }            
        }
        
        

            let huesRef = dataBaseRef.child("users").child(_user.uid).child("hues")
            huesRef.observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                
                
                if snapshot.exists() {
                    // TODO: to refactor iterate?
                    
                    if let wanderlust = snapshot.value![Topic.Wanderlust]  {
                        if self.editedHues![Topic.Wanderlust]?.characters.count > 0 {
                            self.hues![0].data = ProfileHueModel(title: HueTitle.Wanderlust, description: (wanderlust as? String)!, type: Topic.Wanderlust)

                        }else {
                            if let unWrappedDetail = wanderlust as? String where !unWrappedDetail.isEmpty  {
                                self.hues![0].data = ProfileHueModel(title: HueTitle.Wanderlust, description: unWrappedDetail, type: Topic.Wanderlust)
                            }
                        }

                    }
                    
                    if let food = snapshot.value![Topic.OnMyPlate]  {
                        if self.editedHues![Topic.OnMyPlate]?.characters.count > 0 {
                            self.hues![1].data = ProfileHueModel(title: HueTitle.OnMyPlate, description: (food as? String)!, type: Topic.OnMyPlate)
                        }else {
                            if let detail = food as? String where !detail.isEmpty {
                                self.hues![1].data = ProfileHueModel(title: HueTitle.OnMyPlate, description: detail, type: Topic.OnMyPlate)
                            }
                        }

                    }
                    
                    
                    if let snap = snapshot.value![Topic.RelationshipMusing]  {
                        if self.editedHues![Topic.OnMyPlate]?.characters.count > 0 {
                            self.hues![2].data = ProfileHueModel(title: HueTitle.RelationshipMusing, description: (snap as? String)!, type: Topic.RelationshipMusing)
                        }else {
                            if let detail = snap as? String where !detail.isEmpty  {
                                self.hues![2].data = ProfileHueModel(title: HueTitle.RelationshipMusing, description: detail, type: Topic.RelationshipMusing)
                            }
                        }

                    }
                    
                    if let snap = snapshot.value![Topic.Health]  {
                        if self.editedHues![Topic.Health]?.characters.count > 0 {
                            self.hues![3].data = ProfileHueModel(title: HueTitle.Health, description: (snap as? String)!, type: Topic.Health)
                        }else {
                            if let detail = snap as? String where !detail.isEmpty  {
                                self.hues![3].data = ProfileHueModel(title: HueTitle.Health, description: detail, type: Topic.Health)
                            }
                        }

                    }
                    
                    if let snap = snapshot.value![Topic.DailyHustle]  {
                        if self.editedHues![Topic.DailyHustle]?.characters.count > 0 {
                            self.hues![4].data = ProfileHueModel(title: HueTitle.DailyHustle, description: (snap as? String)!, type: Topic.DailyHustle)
                        }else {
                            if let detail = snap as? String where !detail.isEmpty  {
                                self.hues![4].data = ProfileHueModel(title: HueTitle.DailyHustle, description: detail, type: Topic.DailyHustle)
                            }
                        }

                    }
                    if let snap = snapshot.value![Topic.RayOfLight]  {
                        if self.editedHues![Topic.RayOfLight]?.characters.count > 0 {
                            self.hues![5].data = ProfileHueModel(title: HueTitle.RayOfLight, description: (snap as? String)!, type: Topic.RayOfLight)
                        }else {
                            if let detail = snap as? String where !detail.isEmpty {
                                self.hues![5].data = ProfileHueModel(title: HueTitle.RayOfLight, description: detail, type: Topic.RayOfLight)
                                
                            }
                        }

                    }
                    
                }
            })

    }
}
