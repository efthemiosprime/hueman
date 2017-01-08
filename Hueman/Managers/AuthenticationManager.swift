//
//  AuthenticationManager.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/23/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftOverlays


class AuthenticationManager {
    
    var currentUser: User?
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    struct Static
    {
        private static var instance: AuthenticationManager?
    }
    
    
    class var sharedInstance: AuthenticationManager
    {
        if Static.instance == nil
        {
            Static.instance = AuthenticationManager()
        }
        
        return Static.instance!
    }
    
    
    private init() {
        
        
        let currentAuthenticatedUser = FIRAuth.auth()?.currentUser
        let userRef = databaseRef.child("users").child((currentAuthenticatedUser?.uid)!)
        userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if snapshot.exists() {
                self.currentUser = User(snapshot: snapshot)
                userRef.removeAllObservers()
            }
            
            })
        { error in
            print(error.localizedDescription)
        }
    }
    
    
    func dispose() {
        currentUser = nil
        AuthenticationManager.Static.instance = nil
    }
}

