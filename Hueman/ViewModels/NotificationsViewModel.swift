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
    
    

    func load(complete: ((notifications: [NotificationItem]) -> ())? = nil) {
        let authManager = AuthenticationManager.sharedInstance
        let notificationsRef = self.dataBaseRef.child("notifications").child(authManager.currentUser!.uid)
        notificationsRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            if snapshot.exists() {
                
                var counter:UInt = 0
                let numberOfNotifications = snapshot.childrenCount
                var items = [NotificationItem]()

                for snap in snapshot.children {
                    
                    let notification = Notification(snapshot: snap as! FIRDataSnapshot)
                    let userRef = self.dataBaseRef.child("users").child(notification.fromUid)
                    
                    userRef.observeSingleEventOfType(.Value, withBlock: {
                        userSnapshot in
                        
                        if userSnapshot.exists() {
                            let user = User(snapshot: userSnapshot)
                            let item = NotificationItem(name: user.name, type: notification.type, dateCreated: notification.dateCreated!, photoURL: user.photoURL!, key: notification.feedKey)
                            
                            items.append(item)
                            counter = counter + 1
                            
                            if counter == numberOfNotifications {
                                complete?(notifications: items)
                            }
                            
                        }
                    })
                }
            }
        })
    }

}


struct NotificationItem {
    
    let name: String!
    var type: String!
    var dateCreated: String!
    var photoURL: String!
    var key: String!
    
    init(name: String, type: String, dateCreated: String, photoURL: String, key: String) {
        self.name = name
        self.type = type
        self.dateCreated = dateCreated
        self.photoURL = photoURL
        self.key = key
    }
}
