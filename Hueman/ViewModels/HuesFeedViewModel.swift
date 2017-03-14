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
    
    // MARK: Properties

    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorage!{
        return FIRStorage.storage()
    }
    
    var cachedImages =  NSCache()
    var oldFeeds = [Feed]()
    var feeds = [Feed]()
    var connections: [Connection] = [Connection]()
    var connectionUIDs: [String] = [String]()

    var filteredFeeds = [Feed]()

    override init() {
        super.init()
        

    }
    
    func feetchFeeds(onerror:  ((errorString: String) -> ())? = nil ,completion: (([Feed]) -> ())? = nil) {
        databaseRef.child("feeds").observeSingleEventOfType(.Value, withBlock: {
            feedsSnapshot in
            
            if feedsSnapshot.exists() {
                let feeds: [Feed]  = feedsSnapshot.children.map({(feed) -> Feed in
                    let newFeed: Feed = Feed(snapshot: feed as! FIRDataSnapshot)
                    return newFeed
                })
                .filter({ $0.uid == AuthenticationManager.sharedInstance.currentUser?.uid  || self.connectionUIDs.contains($0.uid!)  })
                .reverse()

                
                self.oldFeeds = feeds
                self.feeds = feeds
                completion?(feeds)
        
            }else {
                onerror?(errorString: "Empty")

            }
            

            
        }) {  error in
            onerror?(errorString: error.localizedDescription)
            print (error.localizedDescription)
        }
    }
    
    func fetchConnections(completion: (() -> ())? = nil, onError:((errorString: String) -> ())? = nil ) {
        let authenticationManager =  AuthenticationManager.sharedInstance
        let currentUser = authenticationManager.currentUser
        let friendsRef = self.databaseRef.child("friends").child((currentUser?.uid)!)
        friendsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if snapshot.exists() {
                self.connections = snapshot.children.map({(con) -> Connection in
                    let connection = Connection(name: (con.value!["name"] as? String)!,
                        location: (con.value!["location"] as? String)!, imageURL: (con.value!["imageURL"] as? String)!, uid: (con.value!["uid"] as? String)!, friendship: (con.value!["friendship"] as? String)!)
                    return connection
                })
                
                self.connectionUIDs = self.connections.map({return $0.uid!})
                print(self.connectionUIDs)
                completion?()
                
            }else {
                onError?(errorString: "Empty")
            }
            
            
            
        }) {(error) in
            onError?(errorString: error.localizedDescription)
            print(error.localizedDescription)
        }
    }
    
    func displayImageFeedWithURL(url: String, cell:FeedImageTableViewCell) {
        
        if let cachedImage = self.cachedImages.objectForKey(url) {
            dispatch_async(dispatch_get_main_queue(), {
                cell.feedImage.image = cachedImage as? UIImage
                cell.activityIndicator.hide()

            })
        }else {
            cell.activityIndicator.show()
            storageRef.referenceForURL(url).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                if error == nil {

                    if let imageData = data {
                        let feedImage = UIImage(data: imageData)
                        self.cachedImages.setObject(feedImage!, forKey:url)
                            
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.feedImage.image = feedImage
                            cell.activityIndicator.hide()

                        })
                    }
                        
                }else {
                    print(error!.localizedDescription)
                }
            })
        }
    }
    
    func displayAuthorProfileImageWithURL(uid: String, cell: AnyObject ) {
        let authorRef = FIRDatabase.database().reference().child("users").queryOrderedByChild("uid").queryEqualToValue(uid)
        authorRef.observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
            
            if let photoURL = snapshot.value!["photoURL"] as? String {
                if let cachedImage = self.cachedImages.objectForKey(photoURL) {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if let currentCell = cell as? FeedTextTableViewCell {
                            currentCell.authorProfileImage.image = cachedImage as? UIImage
                        } else {
                            (cell as? FeedImageTableViewCell)!.authorProfileImage.image = cachedImage as? UIImage
                        }
                        
                        
                    })
                }else {
                    self.storageRef.referenceForURL(photoURL).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                        if error == nil {
                            if let imageData = data {
                                let image = UIImage(data: imageData)
                                self.cachedImages.setObject(image!, forKey:photoURL)
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    if let currentCell = cell as? FeedTextTableViewCell {
                                        currentCell.authorProfileImage.image = image
                                    } else {
                                        (cell as? FeedImageTableViewCell)!.authorProfileImage.image = image
                                    }
                                    
                                })
                            }
                            
                        }else {
                            print(error!.localizedDescription)
                        }
                    })
                }
            }
            


        }) { (error) in
            print(error.localizedDescription)
            
        }
        
    }
    
    func displayTotalComments(key:String, cell: AnyObject) {
        

        let commentsRef = databaseRef.child("comments").child(key)
        commentsRef.observeSingleEventOfType(.Value, withBlock:{ snapshot in
            
            if snapshot.exists() {
                if cell is FeedImageTableViewCell {
                    (cell as! FeedImageTableViewCell).commentsLabel.text = String(snapshot.childrenCount)

                }else {
                    (cell as! FeedTextTableViewCell).commentsLabel.text = String(snapshot.childrenCount)
  
                }
            }else {
                if cell is FeedImageTableViewCell {
                    (cell as! FeedImageTableViewCell).commentsLabel.text = "0"
                    
                }else {
                    (cell as! FeedTextTableViewCell).commentsLabel.text = "0"
                    
                }
            }
            

        })
    }
    
    func displayTotalLikes(key:String, cell: AnyObject) {
        
        let likesRef = databaseRef.child("likes").child(key)
        likesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                
                dispatch_async(dispatch_get_main_queue(), {
                    if cell is FeedImageTableViewCell {
                        (cell as! FeedImageTableViewCell).likesLabel.text = String(snapshot.childrenCount)
                    }else {
                        (cell as! FeedTextTableViewCell).likesLabel.text = String(snapshot.childrenCount)
                    }
                })
                

                
            }else {
                dispatch_async(dispatch_get_main_queue(), {
                    if cell is FeedImageTableViewCell {
                        (cell as! FeedImageTableViewCell).likesLabel.text = "0"
                        (cell as! FeedImageTableViewCell).likesButton.selected = false
                        
                    }else {
                        (cell as! FeedTextTableViewCell).likesLabel.text = "0"
                        (cell as! FeedTextTableViewCell).likesButton.selected = false
                        
                    }
                })
            }
        })
    }
    
    func checkFeedForDeletion(key: String, deleteIt: (() -> ())? = nil) {
     //   let feedRef = databaseRef.child("feeds").child(feedKey)
        let likesRef = databaseRef.child("likes").child(key)
        let flagRef = databaseRef.child("flags").child(key)
        

        likesRef.observeSingleEventOfType(.Value, withBlock: {
            likesSnapshot in
            if likesSnapshot.exists() {
                let likesCount = likesSnapshot.childrenCount
                flagRef.observeSingleEventOfType(.Value, withBlock: {
                    flagsSnapshot in
                    if flagsSnapshot.exists() {
                        let flagsCount = flagsSnapshot.childrenCount
  
                        if likesCount < 5 && flagsCount >= 7 {
                            deleteIt?()
                        }
                        
                        if 6...10 ~= likesCount && flagsCount >= 10 {
                            deleteIt?()
                        }
                        
                        if 11...30 ~= likesCount {
                            let ratio = Double(round(Double(likesCount)/Double(flagsCount)))
                            if ratio >= 1.0 {
                                deleteIt?()
                            }
                        }
                        
                        if 31...40 ~= likesCount && flagsCount >= 32 {
                            deleteIt?()
                        }
                        
                        if 41...70 ~= likesCount {
                            let ratio = Double(round(Double(likesCount)/Double(flagsCount)))
                            if ratio >= 1.2 {
                                deleteIt?()
                            }
                        }
                        
                        if 71...80 ~= likesCount && flagsCount >= 58 {
                            deleteIt?()
                        }
                        
                        if likesCount > 80 {
                            let ratio = Double(round(Double(likesCount)/Double(flagsCount)))
                            if ratio >= 1.4 {
                                deleteIt?()
                            }
                        }

                    }
                    
                })
            }
        })

    }
    
    func filterFeeds(input: String) {
        
        self.filteredFeeds = self.feeds.filter( { feed in
            let text = feed.text!
            let topic = feed.topic!
            let author = feed.author!
            return (text.lowercaseString.containsString(input.lowercaseString) || topic.lowercaseString.containsString(input.lowercaseString) || author.lowercaseString.containsString(input.lowercaseString) )
            }
        )
        
    }
    
    func deleteFeed(key: String, completion: (() -> ())? = nil) {
        let feedRef = databaseRef.child("feeds").child(key)
        feedRef.removeValueWithCompletionBlock({
            (error, ref) in
            if( error != nil ) {
                print(error?.localizedDescription)
            }else{
                completion?()
            }
        })
    }
    
    func gcd(likes: Double, flags: Double) -> Double {
        let r = likes % flags
        if r != 0 {
            return gcd(flags, flags: r)
        } else {
            return flags
        }
    }
    

    
}
