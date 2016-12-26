//
//  Comment.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/26/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    
    let name: String!
    var text: String!
    let id: String!
    
    init(name: String, text:String, id: String) {
        
        self.name = name
        self.text = text
        self.id = id
    }
    
    
    init(snapshot: FIRDataSnapshot) {
        
        self.name = snapshot.value!["name"] as? String
        self.text = snapshot.value!["text"] as? String
        self.id = snapshot.value!["id"] as? String

    }
    
    
    
    func toAnyObject() -> [String: AnyObject] {
        return ["name": self.name!, "text":self.text!, "id": self.id]
    }
}
