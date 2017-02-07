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
    var filteredFeeds = [Feed]()

    override init() {super.init()}
    
    func feetchFeeds(completion: (([Feed]) -> ())? = nil) {
        databaseRef.child("feeds").observeSingleEventOfType(.Value, withBlock: {
            feedsSnapshot in
            
            if feedsSnapshot.exists() {
                let feeds: [Feed]  = feedsSnapshot.children.map({(feed) -> Feed in
                    let newFeed: Feed = Feed(snapshot: feed as! FIRDataSnapshot)
                    return newFeed
                }).reverse()
                
                
                self.oldFeeds = feeds
                self.feeds = feeds
                completion?(feeds)
        
            }
            

            
        }) {  error in
            print (error.localizedDescription)
        }
    }
    
    func displayImageFeedWithURL(url: String, cell:FeedImageTableViewCell) {
        
        if let cachedImage = self.cachedImages.objectForKey(url) {
            dispatch_async(dispatch_get_main_queue(), {
                cell.feedImage.image = cachedImage as? UIImage
                    
            })
        }else {
            cell.activityIndicator.show()
            storageRef.referenceForURL(url).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                if error == nil {
                   cell.activityIndicator.hide()

                    if let imageData = data {
                        let feedImage = UIImage(data: imageData)
                        self.cachedImages.setObject(feedImage!, forKey:url)
                            
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.feedImage.image = feedImage
                            
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
    
    func checkFeedForDeletion(likeKey: String, flagKey: String) {
     //   let feedRef = databaseRef.child("feeds").child(feedKey)
        let likesRef = databaseRef.child("likes").child(likeKey)
        let flagRef = databaseRef.child("flags").child(flagKey)
        

        likesRef.observeSingleEventOfType(.Value, withBlock: {
            likesSnapshot in
            if likesSnapshot.exists() {
                let likesCount = likesSnapshot.childrenCount
                flagRef.observeSingleEventOfType(.Value, withBlock: {
                    flagsSnapshot in
                    if flagsSnapshot.exists() {
                        let flagsCount = flagsSnapshot.childrenCount
                        let gcd = self.gcd(66, flags: 39)
                        print("ratio \(66/gcd) : \(39/gcd)")
                       // print("ratio \(self.ratio(likesCount, flagsCount)")
                        
//                        print("flags \(flagsCount)")
//                        print("likes \(likesCount)")

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
    
    func gcd(likes: Double, flags: Double) -> Double {
        let r = likes % flags
        if r != 0 {
            return gcd(flags, flags: r)
        } else {
            return flags
        }
    }

    
}
