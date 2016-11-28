//
//  FeedManager.swift
//  Hueman
//
//  Created by Efthemios Prime on 11/27/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct FeedManager {
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    
    func createFeed(feed: Feed, feedPosted: (() -> ())? = nil) {

        var currentUser: User!
        let userRef = dataBaseRef.child("users").queryOrderedByChild("email").queryEqualToValue(FIRAuth.auth()!.currentUser!.email)
        userRef.observeEventType(.Value, withBlock: {
            snapshot in
            
            for userInfo in snapshot.children {
                currentUser = User(snapshot: userInfo as! FIRDataSnapshot)
            }
            
            var newFeed = feed
            newFeed.author = currentUser!.name
            newFeed.uid = FIRAuth.auth()!.currentUser!.uid
            
            
            let feedRef = self.dataBaseRef.child("feeds").childByAutoId()
            feedRef.setValue(newFeed.toAnyObject(), withCompletionBlock: {
                (error, ref) in
                if error == nil {
                    feedPosted?()
                }
            })
            
        }) { (error) in
            print("error: " + error.localizedDescription    )
        }
        
        
        

    }
    
    
}
