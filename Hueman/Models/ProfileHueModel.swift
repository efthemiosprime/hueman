//
//  ProfileHueModel.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/30/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase

struct ProfileHueModel {
    
    let title: String!
    let description: String!
    let type: String!
    
    init(title: String, description:String, type: String) {
        
        self.title = title
        self.description = description
        self.type = type

    }
    
    init(snapshot: FIRDataSnapshot) {
        
        self.title = snapshot.value!["title"] as? String
        self.description = snapshot.value!["description"] as? String
        self.type = snapshot.value!["type"] as? String
        
    }
    
    
    func toAnyObject() -> [String: AnyObject] {
        return ["title": self.title!, "description":self.description!, "type": self.type]
    }
    
}
