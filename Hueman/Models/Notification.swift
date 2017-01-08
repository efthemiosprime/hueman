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
    
    let fromUid: String!
    let id: String!
    var type: String!
    var dateCreated: String?
    var createdAt: AnyObject?
    var feedKey: String!
    
    init(fromUid: String, id: String, type: String, feedKey: String) {
        
        self.fromUid = fromUid
        self.id = id
        self.feedKey = feedKey
        self.type = type
        self.createdAt = [".sv": "timestamp"]

    }
    
    
    init(snapshot: FIRDataSnapshot) {
        
        self.fromUid = snapshot.value!["fromUid"] as? String
        self.id = snapshot.value!["id"] as? String
        self.feedKey = snapshot.value!["feedKey"] as? String
        self.type = snapshot.value!["type"] as! String
        if snapshot.value!["created_at"] != nil {
            if let date = snapshot.value!["created_at"] as? NSTimeInterval{
                let dateCreated = NSDate(timeIntervalSince1970: date/1000)
                let now: NSDate = NSDate()
                self.dateCreated = now.offsetFrom(dateCreated)
            }
        }
    }
    
    

    func toAnyObject() -> [String: AnyObject] {
        return ["fromUid": self.fromUid!, "id": self.id, "created_at": self.createdAt!, "type": self.type, "feedKey": self.feedKey]
    }
}
