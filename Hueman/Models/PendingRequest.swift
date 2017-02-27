//
//  PendingRequest.swift
//  Hueman
//
//  Created by Efthemios Prime on 2/26/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//


import Foundation

struct PendingRequest {
    
    let recipient: String? // to
    
    init(to:String) {
        
        self.recipient = to
    }
    
    
    func toAnyObject() -> [String: AnyObject] {
        return ["recipient":self.recipient!]
    }
}
