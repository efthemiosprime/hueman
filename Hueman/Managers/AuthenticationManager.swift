//
//  AuthenticationManager.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/23/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftOverlays


class AuthenticationManager {
    
    static let sharedInstance = AuthenticationManager()
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var currentUser: User?
    
    private init() {
        print("auth")
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
    
}
