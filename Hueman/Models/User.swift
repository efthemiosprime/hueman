//
//  User.swift
//  Hueman
//
//  Created by Efthemios Prime on 11/27/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct User {
    
    var name: String!
    var email: String?
    var dob: String!
    var location: String?
    var photoURL: String?
    var password: String?
    var bio: String?
    var uid: String?
    var ref: FIRDatabaseReference?
    var key: String?
    
    init(snapshot: FIRDataSnapshot) {
        
        key = snapshot.key
        ref = snapshot.ref
        
        name = snapshot.value!["name"] as! String
        dob = snapshot.value!["dob"] as! String
        bio = snapshot.value!["bio"] as? String
        location = snapshot.value!["location"] as? String
        email = snapshot.value!["email"] as? String

        photoURL = snapshot.value!["photoURL"] as? String
        
        uid = snapshot.value!["uid"] as? String
        

    }
    
    init(name: String, uid: String, email: String, password:String, dob: String, location: String, bio: String, photoURL: String = "") {
        self.name = name
        self.uid = uid
        self.email = email
        self.password = password
        self.dob = dob
        self.location = location
        self.bio = bio
        self.photoURL = photoURL
    }
    
    init(name: String, email: String, password: String, dob: String, location: String, bio: String, photoURL: String = "") {
        self.name = name
        self.email = email
        self.password = password
        self.dob = dob
        self.location = location
        self.bio = bio
        self.photoURL = photoURL
        
    }
}
