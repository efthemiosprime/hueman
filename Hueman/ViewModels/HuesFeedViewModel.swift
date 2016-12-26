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

    override init() {super.init()}
    
    func feetchFeeds(completion: (([Feed]) -> ())? = nil) {
        databaseRef.child("feeds").observeSingleEventOfType(.Value, withBlock: {
            feedsSnapshot in
            
            let feeds: [Feed]  = feedsSnapshot.children.map({(feed) -> Feed in
                let newFeed: Feed = Feed(snapshot: feed as! FIRDataSnapshot)
                return newFeed
            }).reverse()
            
            
            self.oldFeeds = feeds
            completion?(feeds)

            
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
            storageRef.referenceForURL(url).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                if error == nil {
                        
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
                                    if let imageData = data {
                                        if let currentCell = cell as? FeedTextTableViewCell {
                                            currentCell.authorProfileImage.image = image
                                        } else {
                                            (cell as? FeedImageTableViewCell)!.authorProfileImage.image = image
                                        }
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
    
}
