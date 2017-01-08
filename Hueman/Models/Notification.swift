//
//  Notification.swift
//  Hueman
//
//  Created by Efthemios Prime on 1/8/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//


import Foundation
import Firebase

struct Notification {
    
    enum Type : String {
        case Like = "like", Comment = "comment"
    }

    
    
    let name: String!
    var text: String!
    let id: String!
    var imageURL: String!
    var dateCreated: String!
    var type: Type!
    var createdAt: AnyObject?
    
    init(name: String, text:String, id: String, imageURL: String, dateCreated: String, type: Type) {
        
        self.name = name
        self.text = text
        self.id = id
        self.imageURL = imageURL
        self.dateCreated = dateCreated
    }
    
    
    init(snapshot: FIRDataSnapshot) {
        
        self.name = snapshot.value!["name"] as? String
        self.text = snapshot.value!["text"] as? String
        self.id = snapshot.value!["id"] as? String
        self.imageURL = snapshot.value!["imageURL"] as? String
        
        
        if snapshot.value!["created_at"] != nil {
            if let date = snapshot.value!["created_at"] as? NSTimeInterval{
                let dateCreated = NSDate(timeIntervalSince1970: date/1000)
                let now: NSDate = NSDate()
                self.dateCreated = now.offsetFrom(dateCreated)
            }
        }

        
        
    }
    
    
    
    func toAnyObject() -> [String: AnyObject] {
        
        let theType = String(self.type)
        return ["name": self.name!, "text":self.text!, "id": self.id, "imageURL": self.imageURL, "created_at": self.createdAt!, "type": theType]
    }
}
