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
    let imageURL: String!
    var key: String?
    var createdAt: AnyObject?
    var dateCreated: String?

    init(name: String, text:String, id: String, imageURL: String) {
        
        self.name = name
        self.text = text
        self.id = id
        self.imageURL = imageURL
        self.createdAt = [".sv": "timestamp"]


    }
    
    
    init(snapshot: FIRDataSnapshot) {
        
        self.key = snapshot.key
        self.name = snapshot.value!["name"] as? String
        self.text = snapshot.value!["text"] as? String
        self.id = snapshot.value!["id"] as? String
        self.imageURL = snapshot.value!["imageURL"] as? String

        if snapshot.value!["created_at"] != nil {
            
            if let date = snapshot.value!["created_at"] as? NSTimeInterval{
                
                let timeStamp  = NSDate(timeIntervalSince1970: date/1000)
                let now: NSDate = NSDate()
                self.dateCreated = now.offsetFrom(timeStamp)
            }
        }
        
    }
    
    
    
    func toAnyObject() -> [String: AnyObject] {
        return ["name": self.name!, "text":self.text!, "id": self.id, "created_at": self.createdAt!, "imageURL": self.imageURL]
    }
}
