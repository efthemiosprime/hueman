//
//  Request.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/19/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation

struct Request {
    
    let requester: String? // from
    let recipient: String? // to
    let id: String?
    
    init(from: String, to:String, id: String) {
        
        self.requester = from
        self.recipient = to
        self.id = id
        
    }
    
    
    func toAnyObject() -> [String: AnyObject] {
        return ["from": self.requester!, "to":self.recipient!, "id": self.id!]
    }
}
