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
    var email: String!
    var birthday: UserBirthday?
    var location: UserLocation?
    var photoURL: String?
    var bio: String?
    var uid: String!
    var ref: FIRDatabaseReference?
    var key: String?
    var hues = [String: String]()
    
    
    init(snapshot: FIRDataSnapshot) {
        
        key = snapshot.key
        ref = snapshot.ref
        
        name = snapshot.value!["name"] as! String

        bio = snapshot.value!["bio"] as? String
        email = snapshot.value!["email"] as! String

        photoURL = snapshot.value!["photoURL"] as? String
        
        uid = snapshot.value!["uid"] as! String
        
        if let unwrappedHues = snapshot.value!["hues"] as? [String: String] {
            hues = unwrappedHues
        }

        if let unwrappedBirthday = snapshot.value!["birthday"] as? [String: AnyObject] {
            birthday = UserBirthday(date: unwrappedBirthday["date"]! as! String, visible: (unwrappedBirthday["visible"] as? Bool)!)
        }
        
         if let unwrappedLocation = snapshot.value!["location"] as? [String: AnyObject] {
            location = UserLocation(location: unwrappedLocation["location"]! as! String, visible: (unwrappedLocation["visible"] as? Bool)!)
        }
    }
    
    init(email: String, name: String, userId: String) {
        self.email = email
        self.name = name
        self.uid = userId
    }
    
    init(email: String, name: String, userId: String, photoURL: String) {
        self.email = email
        self.name = name
        self.uid = userId
        self.photoURL = photoURL
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["email": self.email, "name":self.name, "uid": self.uid!, "birthday": self.birthday!.toAnyObject(), "location": self.location!.toAnyObject(), "bio": self.bio!, "photoURL": self.photoURL!, "hues": self.hues]
    }
    
}

struct UserBirthday {
    var date: String?
    var visible: Bool = false
    
    init(date: String, visible: Bool = false) {
        self.date = date
        self.visible = visible
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["date": self.date!, "visible": self.visible]
    }
}

struct UserLocation {
    var location: String?
    var visible = false
    
    init(location: String, visible: Bool = false) {
        self.location = location
        self.visible = visible
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["location": self.location!, "visible": self.visible]

    }
}
