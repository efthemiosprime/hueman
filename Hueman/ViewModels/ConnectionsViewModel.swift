//
//  ConnectionsViewModel.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/23/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation

class ConnectionsViewModel: NSObject {
    
    
    override init() {
        super.init()
    }
    
    func fetchConnections(completion: (([Connection]) -> ())? = nil) {
        let authenticationManager =  AuthenticationManager.sharedInstance
        let currentUser = authenticationManager.currentUser
        let friendsRef = authenticationManager.databaseRef.child("friends").child((currentUser?.uid)!)
        friendsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            let connections = snapshot.children.map({(con) -> Connection in
                let connection = Connection(name: (con.value!["name"] as? String)!,
                    location: (con.value!["location"] as? String)!, imageURL: (con.value!["imageURL"] as? String)!, uid: (con.value!["uid"] as? String)!, friendship: (con.value!["friendship"] as? String)!)
                return connection
            }).sort({ (user1, user2) -> Bool in
                user1.name < user2.name })
            
            completion?(connections)
            
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    
    func fetchAllRequests(withRequests: (Bool) -> Void) {
        
        let authenticationManager =  AuthenticationManager.sharedInstance
        let currentUser = authenticationManager.currentUser
        let requestRef = authenticationManager.databaseRef.child("requests").child((currentUser?.uid)!)
        
        requestRef.observeSingleEventOfType(.Value, withBlock:{
            snapshot in
            
            withRequests(snapshot.exists())
      
            
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    
}
