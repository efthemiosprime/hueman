//
//  ConnectionRequest.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/19/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation

struct ConnectionRequest {
    
    let from: String?
    let to: String?
    let id: String?
    
    init(from: String, to:String, id: String) {
        
        self.from = from
        self.to = to
        self.id = id
        
    }
    
    
    func toAnyObject() -> [String: AnyObject] {
        return ["from": self.from!, "to":self.to!, "id": self.id!]
    }
}
