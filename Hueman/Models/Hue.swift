//
//  Hue.swift
//  Hueman
//
//  Created by Efthemios Prime on 1/1/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import Foundation

struct Hue {
    
    var topic: String!
    var detail: String!
    
    
    init(topic: String, detail: String ) {
        
        self.detail = detail
        self.topic = topic

    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["topic": self.topic!, "detail":self.detail!]
    }
}
