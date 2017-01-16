////
////  FeedViewModel.swift
////  Hueman
////
////  Created by Efthemios Prime on 1/15/17.
////  Copyright © 2017 Efthemios Prime. All rights reserved.
////
//
//import Foundation
//import FirebaseAuth
//import FirebaseStorage
//import FirebaseDatabase
//
//class FeedViewModel: NSObject {
//    
//    var databaseRef: FIRDatabaseReference! {
//        return FIRDatabase.database().reference()
//    }
//    
//    var storageRef: FIRStorage!{
//        return FIRStorage.storage()
//    }
//    
//    var cachedImage =  NSCache()
//    
//    func displayImageFeedWithURL(url: String) {
//        
//        if let cachedImage = self.cachedImage.objectForKey(url) {
//            dispatch_async(dispatch_get_main_queue(), {
//                cell.feedImage.image = cachedImage as? UIImage
//                
//            })
//        }else {
//            cell.activityIndicator.show()
//            storageRef.referenceForURL(url).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
//                if error == nil {
//                    cell.activityIndicator.hide()
//                    
//                    if let imageData = data {
//                        let feedImage = UIImage(data: imageData)
//                        self.cachedImage.setObject(feedImage!, forKey:url)
//                        
//                        dispatch_async(dispatch_get_main_queue(), {
//                            cell.feedImage.image = feedImage
//                            
//                        })
//                    }
//                    
//                }else {
//                    print(error!.localizedDescription)
//                }
//            })
//        }
//    }
//    
//    func displayAuthorProfileImageWithURL(uid: String, cell: AnyObject ) {
//        let authorRef = FIRDatabase.database().reference().child("users").queryOrderedByChild("uid").queryEqualToValue(uid)
//        authorRef.observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
//            
//            if let photoURL = snapshot.value!["photoURL"] as? String {
//                if let cachedImage = self.cachedImage.objectForKey(photoURL) {
//                    
//                    dispatch_async(dispatch_get_main_queue(), {
//                        if let currentCell = cell as? FeedTextTableViewCell {
//                            currentCell.authorProfileImage.image = cachedImage as? UIImage
//                        } else {
//                            (cell as? FeedImageTableViewCell)!.authorProfileImage.image = cachedImage as? UIImage
//                        }
//                    })
//                }else {
//                    self.storageRef.referenceForURL(photoURL).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
//                        if error == nil {
//                            if let imageData = data {
//                                let image = UIImage(data: imageData)
//                                self.cachedImage.setObject(image!, forKey:photoURL)
//                                
//                                dispatch_async(dispatch_get_main_queue(), {
//                                    if let currentCell = cell as? FeedTextTableViewCell {
//                                        currentCell.authorProfileImage.image = image
//                                    } else {
//                                        (cell as? FeedImageTableViewCell)!.authorProfileImage.image = image
//                                    }
//                                    
//                                })
//                            }
//                            
//                        }else {
//                            print(error!.localizedDescription)
//                        }
//                    })
//                }
//            }
//            
//            
//            
//        }) { (error) in
//            print(error.localizedDescription)
//            
//        }
//        
//    }
//    
//    func displayTotalComments(key:String, cell: AnyObject) {
//        
//        
//        let commentsRef = databaseRef.child("comments").child(key)
//        commentsRef.observeSingleEventOfType(.Value, withBlock:{ snapshot in
//            
//            if snapshot.exists() {
//                if cell is FeedImageTableViewCell {
//                    (cell as! FeedImageTableViewCell).commentsLabel.text = String(snapshot.childrenCount)
//                    
//                }else {
//                    (cell as! FeedTextTableViewCell).commentsLabel.text = String(snapshot.childrenCount)
//                    
//                }
//            }else {
//                if cell is FeedImageTableViewCell {
//                    (cell as! FeedImageTableViewCell).commentsLabel.text = "0"
//                    
//                }else {
//                    (cell as! FeedTextTableViewCell).commentsLabel.text = "0"
//                    
//                }
//            }
//            
//            
//        })
//    }
//    
//    func displayTotalLikes(key:String, cell: AnyObject) {
//        
//        let authManager = AuthenticationManager.sharedInstance
//        let currentUID = authManager.currentUser?.uid
//        
//        let likesRef = databaseRef.child("likes").child(key)
//        likesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            if snapshot.exists() {
//                
//                for snap in snapshot.children {
//                    
//                    if let uid = snap.value["uid"] as? String {
//                        if uid == currentUID {
//                            if cell is FeedImageTableViewCell {
//                                (cell as! FeedImageTableViewCell).likesButton.enabled = false
//                            }else {
//                                
//                                (cell as! FeedTextTableViewCell).likesButton.enabled = false
//                                
//                            }
//                        }
//                    }
//                }
//                
//                if cell is FeedImageTableViewCell {
//                    (cell as! FeedImageTableViewCell).likesLabel.text = String(snapshot.childrenCount)
//                }else {
//                    (cell as! FeedTextTableViewCell).likesLabel.text = String(snapshot.childrenCount)
//                }
//            }else {
//                if cell is FeedImageTableViewCell {
//                    (cell as! FeedImageTableViewCell).likesLabel.text = "0"
//                    
//                }else {
//                    (cell as! FeedTextTableViewCell).likesLabel.text = "0"
//                    
//                }
//            }
//        })
//    }
//    
//}
