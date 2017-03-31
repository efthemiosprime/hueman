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
    

    
    
    func dispose() {
        currentUser = nil
        userImageData = nil
        SignupManager.Static.instance = nil
    }
}

// let imagePt = UIImage(data: (caminhodaImagem as! NSData) as Data)
