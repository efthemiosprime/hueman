//
//  Connection.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/5/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Connection {
    
    let name: String?
    var location: UserLocation?
    let imageURL: String?
    let uid: String!
    var friendship:String?
    var pending: Bool = false

    init(name: String, location:UserLocation, imageURL:String, uid: String, friendship: String = "") {
        
        self.name = name
        self.location = location
        self.imageURL = imageURL
        self.uid = uid
        self.friendship = friendship
        
    }
    
    
    init(snapshot: FIRDataSnapshot) {
        
        self.name = snapshot.value!["name"] as? String
       // self.location = snapshot.value!["location"] as? UserLocation
        
        if let unwrappedLocation = snapshot.value!["location"] as? [String: AnyObject] {
            self.location = UserLocation(location: unwrappedLocation["location"]! as! String, visible: (unwrappedLocation["visible"] as? Bool)!)
        }
        
        self.imageURL = snapshot.value!["photoURL"] as? String
        self.uid = snapshot.value!["uid"] as? String
        self.friendship = ""
    }
    
    
    
    func toAnyObject() -> [String: AnyObject] {
        if let unwrappedLocation = location {
            return ["name": self.name!, "location": unwrappedLocation.toAnyObject(), "imageURL": self.imageURL!, "uid": self.uid!, "friendship": self.friendship!]
        }else {
            return ["name": self.name!, "location": "", "imageURL": self.imageURL!, "uid": self.uid!, "friendship": self.friendship!]
        }

    }
}
