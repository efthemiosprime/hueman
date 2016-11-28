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

struct AuthenticationManager {
    
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
    
}
