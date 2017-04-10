//
//  DrawerControllerViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 1/28/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

class DrawerControllerController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    
    var userRef: FIRDatabaseQuery!
    var currentUser: User!
    
    
    let cachedProfileImage = NSCache()
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorage!{
        return FIRStorage.storage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.hidden = true

        userRef = FIRDatabase.database().reference().child("users").queryOrderedByChild("email").queryEqualToValue(FIRAuth.auth()!.currentUser!.email)
        
        
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 61
        profileImage.contentMode = .ScaleToFill
        profileImage.userInteractionEnabled = true
        
        
        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(showProfileAction))
        profileImage.addGestureRecognizer(profileImageTapGesture)
        
        getProfile()
        
    
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier  == "ShowProfile" {
            let profileController = segue.destinationViewController as! ProfileViewController
            profileController.editable = true
            profileController.user = AuthenticationManager.sharedInstance.currentUser
        }
    }
    
    
    func getProfile() {
        if self.currentUser == nil {
            userRef.observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                
                if snapshot.exists() {
                    for userInfo in snapshot.children {
                        
                        self.currentUser = User(snapshot: userInfo as! FIRDataSnapshot)
                    }
                }
                
                self.profileLabel.text = self.currentUser.name
                
                if let profileImageURL = self.currentUser.photoURL where !(self.currentUser.photoURL?.isEmpty)! {
                    if let cachedImage = self.cachedProfileImage.objectForKey(profileImageURL) {
                        self.profileImage.image = cachedImage as? UIImage
                        
                        
                        
                    } else {
                        self.storageRef.referenceForURL(profileImageURL).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                            if error == nil {
                                if let imageData = data {
                                    let image = UIImage(data: imageData)
                                    self.cachedProfileImage.setObject(image!, forKey: profileImageURL)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.profileImage.image = image
                                        
                                    })
                                }
                                
                                self.profileImage.hidden = false

                                
                            }else {
                                print(error!.localizedDescription)
                            }
                        })
                    }
                }
            
            })
        }
    }
    
    @IBAction func privacyPolicyAction(sender: AnyObject) {
    }
    
    @IBAction func appSettingsAction(sender: AnyObject) {
    }
    
    @IBAction func termsAndConditions(sender: AnyObject) {
    }
 
    @IBAction func reportProblemAction(sender: AnyObject) {
    }
    
    @IBAction func helpCenter(sender: AnyObject) {
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("savedFilters") as? [String]) != nil {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("savedFilters")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
            
            
        if FBSDKAccessToken.currentAccessToken() != nil  {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut() // this is an instance function
            FBSDKAccessToken.setCurrentAccessToken(nil)
            FBSDKProfile.setCurrentProfile(nil)

            AuthenticationManager.sharedInstance.dispose()
            let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
            if hasLogin {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasLoginKey")
                NSUserDefaults.standardUserDefaults().setValue(nil, forKeyPath: "email")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            
            let keychainWrapper = KeychainWrapper()
            let vData = keychainWrapper.myObjectForKey("v_Data");
            if (!(vData as? String)!.isEmpty) || vData == nil {
                keychainWrapper.mySetObject(nil, forKey:"v_Data")
                keychainWrapper.writeToKeychain()
                
            }
            
            let caches = NSCache()
            caches.removeAllObjects()
            
            

            
            self.dismissViewControllerAnimated(true, completion: {


            })

            return
        }
        
        
        
        userRef.removeAllObservers()
        
        do {
            
            try FIRAuth.auth()?.signOut()
            
            if FIRAuth.auth()?.currentUser == nil {
                let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
                if hasLogin {
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasLoginKey")
                    NSUserDefaults.standardUserDefaults().setValue(nil, forKeyPath: "email")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                
                let keychainWrapper = KeychainWrapper()
                let vData = keychainWrapper.myObjectForKey("v_Data");
                if (!(vData as? String)!.isEmpty) || vData == nil {
                    keychainWrapper.mySetObject(nil, forKey:"v_Data")
                    keychainWrapper.writeToKeychain()
                    
                }
                
            }
            
            let caches = NSCache()
            caches.removeAllObjects()
            
            if NSUserDefaults.standardUserDefaults().objectForKey("storedEntry") != nil {
                NSUserDefaults.standardUserDefaults().removeObjectForKey("storedEntry")
            }
  
        
            AuthenticationManager.sharedInstance.dispose()
            

            
            
            self.dismissViewControllerAnimated(true, completion: {
                
                if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                        topController.willMoveToParentViewController(nil)
                        topController.view.removeFromSuperview()
                        topController.removeFromParentViewController()
                    }
                }
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let welcomeController = mainStoryboard.instantiateViewControllerWithIdentifier("WelcomeController") as! WelcomeController
                UIApplication.sharedApplication().keyWindow?.rootViewController = welcomeController;
            })
            
            
        } catch let error as NSError {
            print("sign out " + error.localizedDescription)
        }
        
    }
    
    func showProfileAction() {
        if self.revealViewController() != nil {
            self.revealViewController().revealToggleAnimated(true)
        }
        let editable: [String: Bool] = ["editable": true]
        NSNotificationCenter.defaultCenter().postNotificationName("ShowProfile", object: nil, userInfo: editable)
    }
    


}
