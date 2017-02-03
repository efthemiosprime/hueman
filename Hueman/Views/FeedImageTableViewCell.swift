//
//  FeedImageTableViewCell.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/7/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FeedImageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var textFeedLabel: UILabel!
    
    @IBOutlet weak var textCreatedLabel: UILabel!
    
    
    @IBOutlet weak var textAuthorLabel: UILabel!

    @IBOutlet weak var feedImage: UIImageView!
    
    @IBOutlet weak var commentsButton: UIButton!
    
    @IBOutlet weak var likesButton: UIButton!
    
    @IBOutlet weak var popoverButton: UIButton!
    
    @IBOutlet weak var flagButton: UIButton!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: ActivityIndicator!
    
    @IBOutlet weak var authorProfileImage: UIImageView!
    
    var key: String!
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var showCommentsAction: ((UITableViewCell) -> Void)?
    var showLikesAction: ((UITableViewCell) -> Void)?
    var showPopover:((UITableViewCell) -> Void)?
    var showAuthor:((UITableViewCell) -> Void)?
    
    var feed: Feed? {
        didSet{
            if let feed = feed {
                textFeedLabel.text = feed.text
                textAuthorLabel.text = feed.author
                textCreatedLabel.text = feed.dateCreated ?? ""
                feedImage.clipsToBounds = true

                key = feed.key
                
                authorProfileImage.userInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedShowAuthor))
                authorProfileImage.addGestureRecognizer(tapGesture)
                
                update()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        authorProfileImage.layer.shadowColor = UIColor.blackColor().CGColor
        authorProfileImage.layer.shadowOpacity = 0.5
        authorProfileImage.layer.shadowOffset = CGSizeMake(2, 2)
        authorProfileImage.layer.shadowRadius = 3
        authorProfileImage.layer.borderColor = UIColor.UIColorFromRGB(0xffffff).CGColor
        
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTappedPopover(sender: AnyObject) {
        showPopover?(self)
    }

    @IBAction func didTappedComments(sender: AnyObject) {
        showCommentsAction?(self)
    }

    @IBAction func didTappedLikeAction(sender: AnyObject) {
        showLikesAction?(self)
    }
    
    func didTappedShowAuthor() {
        showAuthor?(self)
    }
    
    func update() {
        let authManager = AuthenticationManager.sharedInstance
        if authManager.currentUser == nil {
            authManager.loadCurrentUser({
                let currentUID = authManager.currentUser?.uid
                
                let likesRef = self.databaseRef.child("likes").child(self.key)
                
                likesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    if snapshot.exists() {
                        for snap in snapshot.children {
                            if let uid = snap.value["uid"] as? String, let unWrappedCurrentUid = currentUID {
                                if uid == unWrappedCurrentUid {
                                   dispatch_async(dispatch_get_main_queue(), {
                                        self.likesButton.selected = true
                                   })
                                }
                            }
                        }
                    }
                })
            })
        }else {
            let currentUID = authManager.currentUser?.uid
            
            let likesRef = self.databaseRef.child("likes").child(self.key)
            
            likesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if snapshot.exists() {
                    for snap in snapshot.children {
                        if let uid = snap.value["uid"] as? String, let unWrappedCurrentUid = currentUID {
                            if uid == unWrappedCurrentUid {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.likesButton.selected = true
                                })
                            }
                        }
                    }
                }
            })
        }
    }

}
