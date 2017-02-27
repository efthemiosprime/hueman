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
    let location: String?
    let imageURL: String?
    let uid: String!
    var friendship:String?
    var pending: Bool = false

    init(name: String, location:String, imageURL:String, uid: String, friendship: String = "") {
        
        self.name = name
        self.location = location
        self.imageURL = imageURL
        self.uid = uid
        self.friendship = friendship
        
    }
    
    
    init(snapshot: FIRDataSnapshot) {
        
        self.name = snapshot.value!["name"] as? String
        self.location = snapshot.value!["location"] as? String
        self.imageURL = snapshot.value!["photoURL"] as? String
        self.uid = snapshot.value!["uid"] as? String
        self.friendship = ""
    }
    
    
    
    func toAnyObject() -> [String: AnyObject] {
        return ["name": self.name!, "location":self.location!, "imageURL": self.imageURL!, "uid": self.uid!, "friendship": self.friendship!]
    }
}
