//
//  CommentsViewModel.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/26/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class CommentsViewModel: NSObject {
    
    var comments = [Comment]()
    let cellID = "CommentCell"
    
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    var commentsRef: FIRDatabaseQuery!

    
    override init() {super.init()}
    
    func createComment() {
        
    }
    
    func fetchComments(feed: Feed, completion: (() -> ())? = nil) {
        
      //  activityIndicator.show()
        
        commentsRef = dataBaseRef.child("comments").child(feed.key!)
        commentsRef.observeEventType(.Value, withBlock:{ snapshot in
            
            if snapshot.exists() {
                let comments: [Comment]  = snapshot.children.map({(comment) -> Comment in
                    let newComment: Comment = Comment(snapshot: comment as! FIRDataSnapshot)
                    return newComment
                })
                
                
                self.comments = comments
                completion?()

            }
        })
    }
    
    func postComment(feed: Feed, comment: String, completion: (() -> ())? = nil) {
        
        
        let authManager = AuthenticationManager.sharedInstance
        let uuid = NSUUID().UUIDString
        let newComment = Comment(name: authManager.currentUser!.name, text: comment, id: uuid, imageURL: authManager.currentUser!.photoURL!)
                
                
        let commentRef = dataBaseRef.child("comments").child(feed.key!).childByAutoId()
        commentRef.setValue(newComment.toAnyObject())
            
                    
        if let feedUid = feed.uid {
            if let userUid = authManager.currentUser!.uid {
                if (feedUid != userUid) {
                    let newNotification: Notification = Notification(
                        fromUid: authManager.currentUser!.uid,
                        id: NSUUID().UUIDString,
                                    
                        type: "commented",
                        feedTopic: feed.topic!,
                        feedKey: feed.key!)
                                
                    let notificationManager = NotificationsManager()
                    notificationManager.add(feed.uid!, notification: newNotification, completed: {
                        completion?()
                    })
                }
            }
        }
    }
    
    
    func loadAuthorProfileImage(feed: Feed) {
        commentsRef = dataBaseRef.child("comments").child(feed.key!)
    }
    
    
}
