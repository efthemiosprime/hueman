//
//  NotificationsViewModel.swift
//  Hueman
//
//  Created by Efthemios Prime on 1/8/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class NotificationsViewModel: NSObject {
    

    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    var recent = [NotificationItem]()
    var older = [NotificationItem]()
    var data: [[NotificationItem]] = []
    var sectionTitles = [String]()

    func load(complete: ((notifications: [[NotificationItem]]) -> ())? = nil, onerror: ((errorString: String) -> ())? = nil ) {
        let authManager = AuthenticationManager.sharedInstance
        let notificationsRef = self.dataBaseRef.child("notifications").child(authManager.currentUser!.uid)
        notificationsRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            if snapshot.exists() {
                
                var counter:UInt = 0
                let numberOfNotifications = snapshot.childrenCount
                var items = [NotificationItem]()
                
                let sortedNotifications = snapshot.children.map({(snap) -> Notification in
                    
                    let newNotification: Notification = Notification(snapshot: snap as! FIRDataSnapshot)
                    return newNotification
                    
                })

                for snap in sortedNotifications {
                    
                    let userRef = self.dataBaseRef.child("users").child(snap.fromUid)
                    
                    userRef.observeSingleEventOfType(.Value, withBlock: {
                        userSnapshot in
                        
                        if userSnapshot.exists() {
                            let user = User(snapshot: userSnapshot)
                            let item = NotificationItem(name: user.name, type: snap.type, dateCreated: snap.dateCreated!, feedTopic: snap.feedTopic!, photoURL: user.photoURL!, key: snap.feedKey, date: snap.date!)
                            
                            if let dateCreated = snap.dateCreated  {
                                
                                if dateCreated.rangeOfString("week|day|month|year", options: .RegularExpressionSearch) != nil {
                                    self.older.append(item)
                                    
                                }else {
                                    self.recent.append(item)
                                }
                                
                            }

                            
                            items.append(item)
                            counter = counter + 1
                            
                            if counter == numberOfNotifications {
                                
                                if self.recent.count > 0 {
                                    self.sectionTitles.append("recent")
                                    
                                    let sortedItems = self.recent.sort({ $0.date!.compare($1.date!) == .OrderedAscending })

                                    
                                    self.data.append(sortedItems.reverse())
                                }
                                
                                if self.older.count > 0 {
                                    self.sectionTitles.append("older")
                                    let sortedItems  =   self.older.sort({ $0.date!.compare($1.date!) == .OrderedAscending })

                                    self.data.append(sortedItems.reverse())
                                }
                                

                            
//                                let sortedItems =   items.sort({ $0.date!.compare($1.date!) == .OrderedAscending })

                                complete?(notifications: self.data)
                            }
                            
                        }
                    })
                }
            }else {
                onerror?(errorString: "Empty")
            }
        })
    }
    
    func getFeed(key: String, result: ((feed: Feed) -> ())? = nil)  {
        let feedRef = dataBaseRef.child("feeds").child(key)
        feedRef.observeEventType(.Value, withBlock: {
            snapshot in
            if snapshot.exists() {
                let feed = Feed(snapshot: snapshot)
                result?(feed: feed)
            }
        })
    }
    
    func reset() {
        data.removeAll()
        sectionTitles.removeAll()
        recent.removeAll()
        older.removeAll()
    }


}


struct NotificationItem {
    
    let name: String!
    var type: String!
    var dateCreated: String!
    var photoURL: String!
    var feedTopic: String!
    var key: String!
    var date: NSDate?
    
    init(name: String, type: String, dateCreated: String, feedTopic: String, photoURL: String, key: String, date: NSDate) {
        self.name = name
        self.type = type
        self.dateCreated = dateCreated
        self.photoURL = photoURL
        self.feedTopic = feedTopic
        self.key = key
        self.date = date
    }
}
