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
    
    init(name: String, uid:String) {
        
        self.name = name
        self.uid = uid
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        self.name = snapshot.value!["name"] as? String
        self.uid = snapshot.value!["uid"] as? String
        
    }
    
    
    func toAnyObject() -> [String: AnyObject] {
        return ["name": self.name!, "uid":self.uid!]
    }
    
}
