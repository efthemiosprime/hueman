//
//  CommentCell.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/26/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase



class CommentCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var commentText: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var flagButton: UIButton!
    
    var cachedImages = NSCache()
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    
   // var likedAction: ((_ commentKey: String) -> Void)?
    //var flaggedAction: ((_ commentKey: String) -> Void)?


    var comment: Comment? {
        didSet {
            if let comment = comment {
                self.name.text = comment.name
                self.commentText.text = comment.text
                if let cachedImage = self.cachedImages.objectForKey(comment.imageURL) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.authorImage.image = cachedImage as? UIImage
                        
                    })
                } else {
                    storageRef.referenceForURL(comment.imageURL).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                        if error == nil {
                            
                            if let imageData = data {
                                let feedImage = UIImage(data: imageData)
                                self.cachedImages.setObject(feedImage!, forKey:comment.imageURL)
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.authorImage.image = feedImage
                                    
                                })
                            }
                            
                        }else {
                            print(error!.localizedDescription)
                        }
                    })
                }
                
                update()

            }
        }
    }
    
    
    @IBAction func likedActionHandler(sender: AnyObject) {
        if let key = comment?.key {
            let userUid = (AuthenticationManager.sharedInstance.currentUser?.uid)!
            let commentLike = CommentLike(uid: userUid)
            
            let commentRef = databaseRef.child("commentLikes/\(key)/\(userUid)")
            commentRef.observeSingleEventOfType(.Value, withBlock: { snapshot in

                if snapshot.exists() {
                    if let uid =  snapshot.value!["uid"] as? String {
                        if userUid == uid {
                            commentRef.removeValue()
                            self.likeButton.selected = false
                        }else {
                            commentRef.setValue(commentLike.toAnyObject())
                            self.likeButton.selected = true
                        }
                    }
                    self.getNumberOfLikes()

                }else {
                    commentRef.setValue(commentLike.toAnyObject())
                    self.likeButton.selected = true
                    self.getNumberOfLikes()

                }
            })
        }
    }
    
    @IBAction func flaggedActionHandler(sender: AnyObject) {
        if let key = comment?.key {
            let userUid = (AuthenticationManager.sharedInstance.currentUser?.uid)!
            let commentLike = CommentLike(uid: userUid)
            
            let commentRef = databaseRef.child("commentFlags/\(key)/\(userUid)")
            commentRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if snapshot.exists() {
                    if let uid =  snapshot.value!["uid"] as? String {
                        if userUid == uid {
                            commentRef.removeValue()
                            self.flagButton.selected = false
                        }else {
                            commentRef.setValue(commentLike.toAnyObject())
                            self.flagButton.selected = true
                        }
                    }
                    
                }else {
                    commentRef.setValue(commentLike.toAnyObject())
                    self.flagButton.selected = true
                    
                }
            })
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        authorImage.layer.borderColor = UIColor.UIColorFromRGB(0x999999).CGColor
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func getNumberOfLikes() {
        if let key = comment?.key {
            let likeRefs = databaseRef.child("commentLikes/\(key)")
            likeRefs.observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if snapshot.exists() {
                    self.likeLabel.text = "\(snapshot.childrenCount)"
                }else {
                    self.likeLabel.text = ""

                }
            
            })
        }
    }
    

    
    func update() {
        if let key = comment?.key {
            let userUid = (AuthenticationManager.sharedInstance.currentUser?.uid)!
            let likeRefs = databaseRef.child("commentLikes/\(key)/\(userUid)")
            let flagRefs = databaseRef.child("commentFlags/\(key)/\(userUid)")

            likeRefs.observeSingleEventOfType(.Value, withBlock: { snapshot in
                if snapshot.exists() {
                    print(snapshot.value!["uid"])
                    if let uid =  snapshot.value!["uid"] as? String {
                        if uid == userUid {
                            self.likeButton.selected = true
                        }
                    }

                }else {
                    self.likeButton.selected = false

                }
                
            })
            
            flagRefs.observeSingleEventOfType(.Value, withBlock: { snapshot in
                if snapshot.exists() {
                    print(snapshot.value!["uid"])
                    if let uid =  snapshot.value!["uid"] as? String {
                        if uid == userUid {
                            self.flagButton.selected = true
                        }
                    }
                    
                }else {
                    self.flagButton.selected = false
                    
                }
                
            })
        }
        
        getNumberOfLikes()
    }
    
    
}
