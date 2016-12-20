//
//  Friendship.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/19/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation

struct Friendship {
    
    let from: String?
    let to: String?
    let id: String?
    let status: String?
    
    static let Pending: String = "Pending"
    static let Accepted: String = "Accepted"
    static let Rejected: String = "Rejected"
    

    
    init(from: String, to:String, id: String,  status: String) {
        
        self.from = from
        self.to = to
        self.id = id
        self.status = status
        
    }
    
    
    func toAnyObject() -> [String: AnyObject] {
        return ["from": self.from!, "to":self.to!, "id": self.id!, "status":  status!]
    }
}


