//
//  Like.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/26/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase

struct Like {
    let name: String!
    let uid: String!
    let id: String!
    
    init(name: String, uid:String, id: String) {
        
        self.name = name
        self.uid = uid
        self.id = id
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        self.name = snapshot.value!["name"] as? String
        self.uid = snapshot.value!["uid"] as? String
        self.id = snapshot.value!["id"] as? String
        
    }
    
    
    func toAnyObject() -> [String: AnyObject] {
        return ["name": self.name!, "uid":self.uid!, "id": self.id]
    }
    
}
