//
//  AuthenticationManager.swift
//  Hueman
//
//  Created by Efthemios Prime on 11/26/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKShareKit
import SwiftOverlays

struct FirebaseManager {
    
    let keychainWrapper = KeychainWrapper()
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var storageRef: FIRStorageReference! {
        return FIRStorage.storage().reference()
    }

    
    func logIn(email: String, password: String, loggedIn: (() -> ())? = nil, onerror: ((errorMsg: String) -> ())? = nil) {
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: {
            (user, error) in
            if error == nil {
                if let user = user {
                    
                    NSUserDefaults.standardUserDefaults().setValue(user.uid, forKey: "uid")
                    NSUserDefaults.standardUserDefaults().setValue(email, forKeyPath: "email")

                    self.keychainWrapper.mySetObject(password, forKey: kSecValueData)
                    self.keychainWrapper.writeToKeychain()
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    

                    
                    loggedIn?()
                }
            }else {
                onerror!(errorMsg: (error?.localizedDescription)!)

            }
        })

    }
    
    func loginWithFacebook(url: String, loggedIn: (()->())? = nil) {
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        FIRAuth.auth()?.signInWithCredential(credential, completion: {
            (user, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            if let userEmail = user?.email {
                let exists = self.userExist(userEmail)
                if !exists {
                    self.uploadImageFromURL(url, user: user!, complete: {
                        loggedIn?()
                    })
                }else {
                    loggedIn?()
                }
            }
        })
    }
    
    func signUp(email: String, password:String, name: String, completion: (() -> ())? = nil, onerror: ((errorMsg: String) -> ())? = nil) {
        
        resetStoredUserInfo()
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: {
            (user, error) in
            if error == nil {
                
                let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
                if hasLoginKey == false {
                    NSUserDefaults.standardUserDefaults().setValue(email, forKeyPath: "email")
                }
                
                let changeRequest = user!.profileChangeRequest()
                changeRequest.displayName = name
                
                changeRequest.commitChangesWithCompletion({ (error) in
                    if error == nil {
                        self.keychainWrapper.mySetObject(password, forKey: kSecValueData)
                        self.keychainWrapper.writeToKeychain()
                        
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        
                        var newUserVo = User(email: email, name: name, userId: (user?.uid)! )
                        newUserVo.uid = FIRAuth.auth()?.currentUser?.uid
                        
                        self.saveUserInfo(user, userVo: newUserVo)
                        completion?()
                    }
                    else {
                        
                        onerror!(errorMsg: (error?.localizedDescription)!)

                    }
                    
                })
                
            
            }else {
                print("error: \(error?.localizedDescription)")
                onerror!(errorMsg: (error?.localizedDescription)!)

            }
        })
    }

    private func saveUserInfo(user: FIRUser!, userVo: User) {

        let userInfo = [
            "name": userVo.name!,
            "email": userVo.email!,
            "uid": userVo.uid!,
            "photoURL": userVo.photoURL! ?? "",
            "bio": "",
            "birthday": "",
            "location": ""
        ]
        
       let userRef = dataBaseRef.child("users").child(user.uid)
       userRef.setValue(userInfo)
    }
    
    private func updateUserInfo(user: FIRUser!, userVo: User) {
        
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(enteredEmail)
        
    }
    
    
    func checkLogin(email: String, password: String) -> Bool {
        
        if password == keychainWrapper.myObjectForKey("v_Data") as? String && email == NSUserDefaults.standardUserDefaults().valueForKey("email") as? String {
            return true
        }
        
        return false
    }
    
    func readUser(key: String) {
        print (" +++++++ readUser +++++++++")
        let userRef = dataBaseRef.child("/users/\(key)")
        userRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            if !snapshot.exists() { return }
            
            print(snapshot.value!["email"] as! String)

        })
        
    }
    
    func userExist(email: String) -> Bool {
        let userRef = dataBaseRef.child("users").queryOrderedByChild("email").queryEqualToValue("\(email)")
        userRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            return snapshot.exists()
        })
        
        return false
    }
    
    func resetStoredUserInfo()  {
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        if hasLogin {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("email")
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasLoginKey")
            NSUserDefaults.standardUserDefaults().synchronize()
            

            let vData = keychainWrapper.myObjectForKey("v_Data");
            if (!(vData as? String)!.isEmpty) || vData == nil {
                keychainWrapper.mySetObject(nil, forKey:"v_Data")
                keychainWrapper.writeToKeychain()
                
            }
        }
    }
    
    func uploadImageFromURL(url: String, user: FIRUser, complete:  (() -> ())? = nil) {
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                let trimmedName = user.displayName!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

                
                let imageData = UIImageJPEGRepresentation(UIImage(data: data)!, 0.5)
                let imagePath = "userProfileImage\(user.uid)/\(trimmedName).jpg"
                let imageRef = self.storageRef.child(imagePath)
                let metaData = FIRStorageMetadata()
                metaData.contentType = "image/jpeg"
                
                imageRef.putData(imageData!, metadata: metaData, completion: { (metadata, error) in
                    guard error == nil else {
                        print(error)
                        return
                    }
                    
                    let changeRequest = user.profileChangeRequest()
                    if let photoURL = metadata!.downloadURL(){
                        changeRequest.photoURL = photoURL
                    }
                    
                    changeRequest.commitChangesWithCompletion({
                        error in
                        
                        guard error == nil else {
                            print(error)
                            return
                        }
                        
                        let newUserVo = User(email: (user.email)!, name: (user.displayName)!, userId: (user.uid), photoURL: (changeRequest.photoURL?.absoluteString)! )
                        self.saveUserInfo(user, userVo: newUserVo)
                        
                        AuthenticationManager.sharedInstance.currentUser = newUserVo
                        print(FBSDKAccessToken.currentAccessToken())
                        complete?()
                    })
                    


                })
                
                
                
                
            }
        }
        
        // Run task
        task.resume()
    }
    
    func facebookLogout() {
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut() // this is an instance function
            FBSDKAccessToken.setCurrentAccessToken(nil)
            FBSDKProfile.setCurrentProfile(nil)
        }

        

    }
    
     func manuallyStoreCreds() {
        
        NSUserDefaults.standardUserDefaults().setValue("bongbox@gmail.com", forKeyPath: "email")
        self.keychainWrapper.mySetObject("12qwaszx#", forKey: kSecValueData)
        self.keychainWrapper.writeToKeychain()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
}
