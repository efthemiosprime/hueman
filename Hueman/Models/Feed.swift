//
//  Feed.swift
//  Hueman
//
//  Created by Efthemios Prime on 11/27/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct Feed {
    
    var uid: String?
    var author: String!
    var text: String!
    var id: String!
    var topic: String!
    var createdAt: AnyObject?
    var ref: FIRDatabaseReference!
    var key: String?
    var imageURL: String?
    var dateCreated: String?
    var withImage: Bool?
    var editMode = false
    
    init(snapshot: FIRDataSnapshot) {
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.author = snapshot.value!["author"] as! String
        self.text = snapshot.value!["text"] as! String
        self.topic = snapshot.value!["topic"] as! String
        
        
        self.uid = snapshot.value!["uid"] as? String
        self.imageURL = snapshot.value!["imageURL"] as? String
        self.withImage = snapshot.value!["withImage"] as? Bool
        
        
        if snapshot.value!["created_at"] != nil {

            if let date = snapshot.value!["created_at"] as? NSTimeInterval{
                
                let dateCreated = NSDate(timeIntervalSince1970: date/1000)
                let now: NSDate = NSDate()
                self.dateCreated = now.offsetFrom(dateCreated)
            }
        }

    }
    
    init(author: String, id: String, uid: String, text: String, topic: String, imageURL: String, withImage: Bool = false) {
        self.author = author
        self.id = id
        self.text = text
        self.topic = topic
        self.createdAt = [".sv": "timestamp"]
        self.uid = uid
        self.imageURL = imageURL
        self.withImage = withImage
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["author": self.author, "id":self.id, "uid": self.uid!, "text": self.text, "topic": topic, "created_at": self.createdAt!, "imageURL": imageURL!, "withImage": withImage!]
    }
    
}
