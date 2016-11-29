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

struct AuthenticationManager {
    
    let keychainWrapper = KeychainWrapper()
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }

    
    func logIn(email: String, password: String, loggedIn: (() -> ())? = nil) {
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: {
            (user, error) in
            if error == nil {
                if let user = user {
                    
                    NSUserDefaults.standardUserDefaults().setValue(user.uid, forKey: "uid")

                    loggedIn?()
                }
            }else {
                print(error!.localizedDescription)
            }
        })

    }
    
    func signUp(userVo: User, completion: (() -> ())? = nil) {
        
        let email: String = userVo.email!
        let password: String = userVo.password!
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: {
            (user, error) in
            if error == nil {
                
                let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
                if hasLoginKey == false {
                    NSUserDefaults.standardUserDefaults().setValue(email, forKeyPath: "email")
                }
                
                self.keychainWrapper.mySetObject(password, forKey: kSecValueData)
                self.keychainWrapper.writeToKeychain()
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                NSUserDefaults.standardUserDefaults().synchronize()

                
                
                self.saveUserInfo(user, userVo: userVo)
                completion?()
            }else {
                print("error: \(error?.localizedDescription)")
            }
        })
    }
    
    private func saveUserInfo(user: FIRUser!, userVo: User) {

        let userInfo = [
            "name": userVo.name!,
            "email": userVo.email!,
            "dob": userVo.dob,
            "location": userVo.location,
            "bio": userVo.bio
        ]
        
       let userRef = dataBaseRef.child("users").child(user.uid)
       userRef.setValue(userInfo)
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
    
     func manuallyStoreCreds() {
        
        NSUserDefaults.standardUserDefaults().setValue("bongbox@gmail.com", forKeyPath: "email")
        self.keychainWrapper.mySetObject("12qwaszx#", forKey: kSecValueData)
        self.keychainWrapper.writeToKeychain()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
