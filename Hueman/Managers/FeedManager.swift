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
import SwiftOverlays

struct FeedManager {
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    
    func createFeed(feed: Feed, imageData: NSData? = nil, feedPosted: (() -> ())? = nil) {
        
        var currentUser: User!
        let userRef = dataBaseRef.child("users").queryOrderedByChild("email").queryEqualToValue(FIRAuth.auth()!.currentUser!.email)
        userRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            if snapshot.exists() {
                for userInfo in snapshot.children {
                    currentUser = User(snapshot: userInfo as! FIRDataSnapshot)
                }
                
                var newFeed = feed
                newFeed.author = currentUser!.name
                newFeed.uid = FIRAuth.auth()!.currentUser!.uid
                
                if imageData != nil {
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpeg"
                    let imagePath = "huesfeed/\(FIRAuth.auth()!.currentUser!.uid)/feed\(NSUUID().UUIDString).jpg"
                    let imageRef = self.storageRef.reference().child(imagePath)
                    
                    imageRef.putData(imageData!, metadata: metaData, completion: {
                        (newMetaData, error) in
                        
                        if error == nil {
                            newFeed.imageURL = String(newMetaData!.downloadURL()!)
                            newFeed.withImage = true
                            let feedRef = self.dataBaseRef.child("feeds").childByAutoId()
                            feedRef.setValue(newFeed.toAnyObject(), withCompletionBlock: {
                                (error, ref) in
                                if error == nil {
                                    feedPosted?()
                                }
                            })
                        }
                    })
                    
                }else {
                    let feedRef = self.dataBaseRef.child("feeds").childByAutoId()
                    feedRef.setValue(newFeed.toAnyObject(), withCompletionBlock: {
                        (error, ref) in
                        if error == nil {
                            feedPosted?()
                        }
                    })
                }
            }

            
        }) { (error) in
            print("error: " + error.localizedDescription    )
        }
    }
    
    func editFeed(editedFeed: Feed, key:String, imageData: NSData? = nil, feedEdited: (() -> ())? = nil) {
        


        let feedRef = dataBaseRef.child("feeds/\(key)")
        
        if imageData != nil {
            print(editedFeed.imageURL)
            if let imageURL = editedFeed.imageURL {
                if !imageURL.isEmpty {
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpeg"
                    let imagePath = imageURL
                    let imageRef = self.storageRef.reference().child(imagePath)
                    
                    imageRef.putData(imageData!, metadata: metaData, completion: {
                        (newMetaData, error) in
                        
                        if error == nil {
 
                            
                            
                            let updatedFeed = [
                                "text" : editedFeed.text,
                                "topic" : editedFeed.topic,
                                "imageURL": String(newMetaData!.downloadURL()!),
                                "withImage": true
                            ]
                            
                            
                            feedRef.updateChildValues(updatedFeed as [NSObject : AnyObject], withCompletionBlock: {(err, ref) in
                                if err != nil {
                                    print(err?.description)
                                }else {
                                    feedEdited?()
                            
                                }
                            })
                        }
                    })

                }else {
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpeg"
                    let imagePath = "huesfeed\(FIRAuth.auth()!.currentUser!.uid)/feed\(NSUUID().UUIDString).jpg"
                    let imageRef = self.storageRef.reference().child(imagePath)
                    
                    imageRef.putData(imageData!, metadata: metaData, completion: {
                        (newMetaData, error) in
                        
                        if error == nil {
                            
                            
                            
                            let updatedFeed = [
                                "text" : editedFeed.text,
                                "topic" : editedFeed.topic,
                                "imageURL": String(newMetaData!.downloadURL()!),
                                "withImage": true
                            ]
                            
                            
                            feedRef.updateChildValues(updatedFeed as [NSObject : AnyObject], withCompletionBlock: {(err, ref) in
                                if err != nil {
                                    print(err?.description)
                                }else {
                                    feedEdited?()
                                    
                                }
                            })
                        }
                    })
                }
            }
        }else {
            
            let updatedFeed = [
                "text" : editedFeed.text,
                "topic" : editedFeed.topic
            ]
            
            feedRef.updateChildValues(updatedFeed, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print(err?.description)
                }else {
                    feedEdited?()
                    
                }
            })
            
            
        }


        

    }
    
    func getFeed(feed: Feed, completed: (() -> ())? = nil) {
        completed?()
    }
    
    func getFeedImage(url: String, complete: ((image: UIImage) -> ())? = nil) {
        storageRef.referenceForURL(url).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
            if error == nil {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    complete?(image: image!)
                }
            }else {
                print(error!.localizedDescription)
            }
        })
    }
}
