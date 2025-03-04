//
//  Friendship.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/19/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase

struct Friendship {
    
    let requester: String? // from
    let recipient: String? // to
    let id: String?
    let status: String?
    
    static let Pending: String = "Pending"
    static let Accepted: String = "Accepted"
    static let Rejected: String = "Rejected"
    static let Removed: String = "Removed"
    
    

    init(snapshot: FIRDataSnapshot) {
        
        self.requester = snapshot.value!["requester"] as? String
        self.recipient = snapshot.value!["recipient"] as? String
        self.id = snapshot.value!["id"] as? String
        self.status = snapshot.value!["status"] as? String
        
    }

    
    init(from: String, to:String, id: String,  status: String) {
        
        self.requester = from
        self.recipient = to
        self.id = id
        self.status = status
        
    }
    
    
    func toAnyObject() -> [String: AnyObject] {
        return ["requester": self.requester!, "recipient":self.recipient!, "id": self.id!, "status":  status!]
    }
}


