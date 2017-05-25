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
    
    var requests = [NotificationItem]()
    var recent = [NotificationItem]()
    var older = [NotificationItem]()
    var data: [[NotificationItem]] = []
    var sectionTitles = [String]()
    
    var numberOfNotifications:UInt = 0

    func load(complete: ((notifications: [[NotificationItem]]) -> ())? = nil, onerror: ((errorString: String) -> ())? = nil ) {
        
        let authManager = AuthenticationManager.sharedInstance
        let notificationsRef = self.dataBaseRef.child("notifications").child(authManager.currentUser!.uid)
        
        self.fetchAllRequests({
            
            if self.requests.count > 0 {
                self.sectionTitles.append("connection requests")
                self.data.append(self.requests)
            }

            notificationsRef.observeEventType(.Value, withBlock: {
                snapshot in
                if snapshot.exists() {
                    
                    var counter:UInt = 0
                    self.numberOfNotifications = snapshot.childrenCount
                    var items = [NotificationItem]()
                    
                    let sortedNotifications = snapshot.children.map({(snap) -> Notification in
                        
                        let newNotification: Notification = Notification(snapshot: snap as! FIRDataSnapshot)
                        return newNotification
                        
                    })
                    print("number of notifications \(self.numberOfNotifications)")

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
                                
                                
                                
                                if counter == self.numberOfNotifications {
                                    
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
                    if (self.data.count > 0) {
                        complete?(notifications: self.data)
                    }else {
                        onerror?(errorString: "Empty")
 
                    }
                }
            })
            
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
        requests.removeAll()
    }

    func fetchAllRequests(completion: (() -> ())? = nil) {
        let authManager = AuthenticationManager.sharedInstance

        if let unwrappedUID = authManager.currentUser?.uid {
            let requestRef = dataBaseRef.child("requests").child(unwrappedUID)
            
            requestRef.observeSingleEventOfType(.Value, withBlock:{
                snapshot in
                if snapshot.exists() {
                    
                    let requestCount = snapshot.children.allObjects.count
                    
                    for snap in snapshot.children {
                        if let requester = snap.value!["requester"] as? String {
                            let requestFromRef = self.dataBaseRef.child("/users/\(requester)")
                            
                            requestFromRef.observeSingleEventOfType(.Value, withBlock: {userSnap in
                                
                                if userSnap.exists() {
                                    let user = User(snapshot: userSnap)
                                    var location: String?
                                    if let unwrappedLocation = user.location {
                                        location = unwrappedLocation.location
                                    }else {
                                        location = ""
                                    }
                                    
                                    
                                    let item = NotificationItem(name: user.name, type: "request", dateCreated: "", feedTopic: "", photoURL: user.photoURL!, key: user.key!, date: NSDate(), uid: user.uid, location: location!)
                                    
                                    
                                    self.requests.append(item)
                                    if self.requests.count == requestCount {
                                        completion?()
                                    }
                                }


                              // let userRequest = User(snapshot: userSnap )
                               // self.requests.append(userRequest)
                            }) {(error ) in
                                print(error.localizedDescription)
                                
                            }
                        }
                    }
                }else {
                    completion?()

                }

                
            }) {(error) in
                print(error.localizedDescription)
            }
        }
        
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
    var location: String?
    var uid: String?
    
    init(name: String, type: String, dateCreated: String, feedTopic: String, photoURL: String, key: String, date: NSDate, uid:String = "", location:String = "") {
        self.name = name
        self.type = type
        self.dateCreated = dateCreated
        self.photoURL = photoURL
        self.feedTopic = feedTopic
        self.key = key
        self.date = date
        self.location = location
        self.uid = uid
    }
    

}
