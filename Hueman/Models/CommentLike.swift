//
//  CommentLike.swift
//  Hueman
//
//  Created by Efthemios Prime on 2/25/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase

struct CommentLike {
    
    let uid: String!
    var key: String?

    init(uid:String) {
        
        self.uid = uid
    }
    
    init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        self.uid = snapshot.value!["uid"] as? String
    }
    
    
    func toAnyObject() -> [String: AnyObject] {
        return ["uid":self.uid!]
    }
    
}
