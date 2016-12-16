//
//  Connection.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/5/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation

struct Connection {
    
    let name: String?
    let location: String?
    let imageURL: String?
    let uid: String!

    init(name: String, location:String, imageURL:String, uid: String) {
        
        self.name = name
        self.location = location
        self.imageURL = imageURL
        self.uid = uid
        
    }
}
