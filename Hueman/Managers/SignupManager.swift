//
//  SignupManager.swift
//  Hueman
//
//  Created by Efthemios Prime on 3/29/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase



class SignupManager {
    
    var currentUser :User?
    var userImageData: NSData?
    var userBirthday: UserBirthday?
    var userLocation: UserLocation?

    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var storageRef: FIRStorageReference! {
        return FIRStorage.storage().reference()
    }
    
    
    struct Static
    {
        private static var instance: SignupManager?
    }
    
    
    class var sharedInstance: SignupManager
    {
        if Static.instance == nil
        {
            Static.instance = SignupManager()
        }
        
        return Static.instance!
    }
    
    
    private init() {
    }
    

    func editProfile(completed: (() -> ())? = nil) {
        let currentAuthUser = FIRAuth.auth()?.currentUser
        

        
        var imageURL = ""
        if let name = currentUser?.name {
            let trimName = String(name.characters.map {$0 == " " ? "_" : $0})
            if let unWrappedUID = currentAuthUser?.uid {
                imageURL = "profile_images/\(unWrappedUID)/\(trimName.lowercaseString).jpg"
            }
        }
        
        let imageRef = storageRef.child(imageURL)
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        
        let changeRequest = currentAuthUser?.profileChangeRequest()

        if let imageData = userImageData {
            imageRef.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                guard error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                
                if let photoURL = metadata!.downloadURL() {
                    changeRequest!.photoURL = photoURL
                }
                
                
                changeRequest!.displayName = self.currentUser?.name
                
                changeRequest?.commitChangesWithCompletion({
                    error in
                    guard error == nil else {
                        print(error?.localizedDescription)
                        return
                    }
                    
                    if let birthday = self.userBirthday {
                        self.currentUser?.birthday = birthday
                    }
                    
                    if let location = self.userLocation {
                        self.currentUser?.location = location
                    }
                    self.currentUser?.bio = ""
                    
                    self.currentUser?.photoURL = changeRequest?.photoURL?.absoluteString
                    
                    let uid = (currentAuthUser?.uid)!
                    let updateRef = self.dataBaseRef.child("/users/\(uid)")
                    
                    updateRef.updateChildValues(self.currentUser!.toAnyObject())
                    
                    
                    completed?()
                    
                }) // commitChangesWithCompletion
            }) // imageRef
        } else {
            
        }
        
    }
    
    
    func dispose() {
        currentUser = nil
        userImageData = nil
        SignupManager.Static.instance = nil
    }
}

// let imagePt = UIImage(data: (caminhodaImagem as! NSData) as Data)
