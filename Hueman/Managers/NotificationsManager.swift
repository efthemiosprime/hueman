//
//  NotificationsManager.swift
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

struct NotificationsManager {
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    func add(userUidToNotfiy: String, notification: Notification, completed: (() -> ())? = nil) {
        

        let notificationsRef = self.dataBaseRef.child("notifications").child(userUidToNotfiy).childByAutoId()
        notificationsRef.setValue(notification.toAnyObject())
        
        let notificationsCountRef = self.dataBaseRef.child("notificationsCount").child(userUidToNotfiy).childByAutoId()
        notificationsCountRef.setValue(notification.id)
        
        completed?()

    }
    
    
    func getTotalNotifications(completed: ((badgeCount: UInt) -> ())? = nil) {
        
        let authManager = AuthenticationManager.sharedInstance
        let notificationsCountRef = self.dataBaseRef.child("notificationsCount").child(authManager.currentUser!.uid!)
        
        notificationsCountRef.observeEventType(.Value, withBlock: {
            snapshot in
            
            if snapshot.exists() {
                completed?(badgeCount: snapshot.childrenCount)
            }
        })
    }
    
    func deleteNotifications(completed: (() -> ())? = nil) {
        let authManager = AuthenticationManager.sharedInstance
        let notificationsCountRef = self.dataBaseRef.child("notificationsCount").child(authManager.currentUser!.uid!)
        
        notificationsCountRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            if snapshot.exists() {
                notificationsCountRef.removeValue()
            }
        })
    }


    
}
