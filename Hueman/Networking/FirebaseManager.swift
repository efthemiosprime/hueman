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
import SwiftOverlays

struct FirebaseManager {
    
    let keychainWrapper = KeychainWrapper()
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
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
            "photoURL": "",
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
    
     func manuallyStoreCreds() {
        
        NSUserDefaults.standardUserDefaults().setValue("bongbox@gmail.com", forKeyPath: "email")
        self.keychainWrapper.mySetObject("12qwaszx#", forKey: kSecValueData)
        self.keychainWrapper.writeToKeychain()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
}
