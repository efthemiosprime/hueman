//
//  HuesFeedViewModel.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/24/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class HuesFeedViewModel: NSObject {
    
    static let CELL_TEXT_IDENTIFIER = "huesfeedtextcell"
    static let CELL_IMAGE_IDENTIFIER = "huesfeedimagecell"
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var oldFeeds = [Feed]()

    override init() {super.init()}
    
    func feetchFeeds(completion: (([Feed]) -> ())? = nil) {
        databaseRef.child("feeds").observeSingleEventOfType(.Value, withBlock: {
            feedsSnapshot in
            
            let feeds: [Feed]  = feedsSnapshot.children.map({(feed) -> Feed in
                let newFeed: Feed = Feed(snapshot: feed as! FIRDataSnapshot)
                return newFeed
            }).reverse()
            
            
            self.oldFeeds = feeds
            completion?(feeds)

            
        }) {  error in
            print (error.localizedDescription)
        }
    }
    
}
