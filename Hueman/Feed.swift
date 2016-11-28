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
    
    var uid: String!
    var author: String!
    var text: String!
    var id: String!
    var topic: String!
    var ref: FIRDatabaseReference!
    var key: String?
    
    init(snapshot: FIRDataSnapshot) {
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.author = snapshot.value!["author"] as! String
        self.text = snapshot.value!["text"] as! String
        self.topic = snapshot.value!["topic"] as! String
        self.uid = snapshot.value!["uid"] as! String

    }
    
    init(author: String, id: String, uid: String, text: String, topic: String) {
        self.author = author
        self.id = id
        self.text = text
        self.topic = topic
        self.uid = uid
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["author": self.author, "id":self.id, "text": self.text, "topic": topic]
    }
    
}
