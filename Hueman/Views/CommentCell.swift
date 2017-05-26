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
    @IBOutlet weak var createdAtLabel: UILabel!
    
    var cachedImages = NSCache()
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    
    var deleteAction: ((key: String) -> Void)?

    var commentKey: String?

    var comment: Comment? {
        didSet {
            if let comment = comment {
                self.name.text = comment.name
                self.commentText.text = comment.text
                self.createdAtLabel.text = comment.dateCreated ?? ""

                if let cachedImage = self.cachedImages.objectForKey(comment.imageURL) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.authorImage.image = cachedImage as? UIImage
                        
                    })
                } else {
                    if comment.imageURL.isEmpty {
                        print("is empty")
                    }else {
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
            
            let flagRefs = databaseRef.child("commentFlags/\(key)/\(userUid)")
            flagRefs.observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if snapshot.exists() {
                    if let uid =  snapshot.value!["uid"] as? String {
                        if userUid == uid {
                            flagRefs.removeValue()
                            self.flagButton.selected = false
                        }else {
                            flagRefs.setValue(commentLike.toAnyObject(), withCompletionBlock: { (error, dbref) in
                                
                                self.checkForDeletion(key, deleteIt: {
                                    self.deleteAction?(key: key)

                                })
                                
                            })
                            self.flagButton.selected = true
                        }
                    }
                    
                }else {
                    flagRefs.setValue(commentLike.toAnyObject(), withCompletionBlock: { (error, dbref) in
                        
                        self.checkForDeletion(key, deleteIt: {
                            self.deleteAction?(key: key)

                        })
                    })
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
    
    

    func flag(dbRef: FIRDatabaseReference, key: String, obj: AnyObject) {
        dbRef.setValue(obj, withCompletionBlock: { (error, dbref) in
            
            self.checkForDeletion(key, deleteIt: {
            
                let commentRef = self.databaseRef.child("comments/\(key)")
                commentRef.removeValueWithCompletionBlock({ (error, ref) in
                  //  self.deleteAction?(key)
                })
            })
            
        })

    }
    
    func checkForDeletion(key: String, deleteIt: (() -> ())? = nil) {
        let likeRefs = self.databaseRef.child("commentLikes/\(key)")
        let flagRefs = self.databaseRef.child("commentFlags/\(key)")
        
        flagRefs.observeSingleEventOfType(.Value, withBlock: { flagSnapshot in
            if flagSnapshot.exists() {
                let flagsCount = flagSnapshot.childrenCount
                
                if flagsCount >= 3 {
                    deleteIt?()
                }
                
                likeRefs.observeSingleEventOfType(.Value, withBlock: { likeSnapshot in
                    if likeSnapshot.exists() {
                        let likesCount = likeSnapshot.childrenCount

                        if 0...5 ~= likesCount && flagsCount >= 3 {
                            deleteIt?()
                        }
                        
                        if 6...10 ~= likesCount && flagsCount >= 5 {
                            deleteIt?()
                        }
                        
//                        if 11...30 ~= likesCount {
//                            let ratio = Double(round(Double(likesCount)/Double(flagsCount)))
//                            if ratio >= 1.0 {
//                                deleteIt?()
//                            }
//                        }
//                        
//                        if 31...40 ~= likesCount && flagsCount >= 32 {
//                            deleteIt?()
//                        }
//                        
//                        if 41...70 ~= likesCount {
//                            let ratio = Double(round(Double(likesCount)/Double(flagsCount)))
//                            if ratio >= 1.2 {
//                                deleteIt?()
//                            }
//                        }
//                        
//                        if 71...80 ~= likesCount && flagsCount >= 58 {
//                            deleteIt?()
//                        }
                        
                        if likesCount > 10 {
                            let ratio = Double(round(Double(likesCount)/Double(flagsCount)))
                            if ratio >= 2.1 {
                                deleteIt?()
                            }
                        }
                    }
                })
                
            }
        })
    }
    
    
}
