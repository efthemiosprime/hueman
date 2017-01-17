//
//  FeedController.swift
//  Hueman
//
//  Created by Efthemios Prime on 1/15/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class FeedController: UIViewController {
    
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
    
    
    var backItem: UIBarButtonItem!
    
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorage!{
        return FIRStorage.storage()
    }
    
    var feed: Feed?
    
    
    var key: String!
    var cachedImages = NSCache()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topic = feed?.topic {
            switch topic {
            case Topic.Wanderlust:
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.Wanderlust)
                break;
            case Topic.DailyHustle:
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.DailyHustle)
                break;
            case Topic.Health:
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.Health)
                break;
            case Topic.RayOfLight:
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.RayOfLight)
                break;
                
            case Topic.OnMyPlate:
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.OnMyPlate)
                break;
                
            default:
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.RelationshipMusing)
            }
        }
        self.navigationController?.navigationBar.translucent = false
        backItem = UIBarButtonItem(image: UIImage(named: "back-bar-item"), style: .Plain, target: self, action: #selector(FeedController.backAction))
        self.navigationItem.leftBarButtonItem = backItem
        feedImage.clipsToBounds = true
        
        textFeedLabel.text = feed!.text
        textAuthorLabel.text = feed!.author
        textCreatedLabel.text = feed!.dateCreated ?? ""
        key = feed!.key
        
        if !(feed?.imageURL?.isEmpty)! {
            if let imageURL = feed?.imageURL {
                displayImageFeedWithURL(imageURL)
            }
        }
        
        if let uid = feed?.uid {
            displayAuthorProfileImageWithURL(uid)
        }
        
        if let key = feed?.key {
            displayTotalComments(key)
            displayTotalLikes(key)
        }
        
        
        authorProfileImage.userInteractionEnabled = true
        let tapIconGesture = UITapGestureRecognizer(target: self, action: #selector(showAuthorProfile))
        authorProfileImage.addGestureRecognizer(tapIconGesture)

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)


    }

    func showAuthorProfile() {
        /*
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        if let unwrappedUid = feed?.uid {
            
            
            let userRef = self.databaseRef.child("users").child(unwrappedUid )
            userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                if snapshot.exists() {
                    
                    let user = User(snapshot: snapshot)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let profileController = storyboard.instantiateViewControllerWithIdentifier("ProfileView") as? ProfileViewController
                    profileController?.user = user
                    
                    
                    self.parentViewController!.addChildViewController(profileController!)
                    profileController?.view.frame =  CGRectMake(screenWidth, 0.0, screenWidth, screenHeight)
                    self.parentViewController!.view.addSubview((profileController?.view)!)
                    profileController!.didMoveToParentViewController(self.parentViewController!)
                }
                
            })
            
        }
        */
    }
    
    
    func displayImageFeedWithURL(url:String) {
        if let cachedImage = self.cachedImages.objectForKey(url) {
            dispatch_async(dispatch_get_main_queue(), {
                self.feedImage.image = cachedImage as? UIImage
            })
        }else {
            storageRef.referenceForURL(url).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                if error == nil {
        
                    if let imageData = data {
                        let feedImage = UIImage(data: imageData)
                        self.cachedImages.setObject(feedImage!, forKey:url)
        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.feedImage.image = feedImage
        
                        })
                    }
        
                }else {
                        print(error!.localizedDescription)
                }
            })
        }
    }
    
    func displayAuthorProfileImageWithURL(uid: String ) {
        let authorRef = FIRDatabase.database().reference().child("users").queryOrderedByChild("uid").queryEqualToValue(uid)
        authorRef.observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
            
            if let photoURL = snapshot.value!["photoURL"] as? String {
                if let cachedImage = self.cachedImages.objectForKey(photoURL) {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.authorProfileImage.image = cachedImage as? UIImage

                    })
                }else {
                    self.storageRef.referenceForURL(photoURL).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                        if error == nil {
                            if let imageData = data {
                                let image = UIImage(data: imageData)
                                self.cachedImages.setObject(image!, forKey:photoURL)
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.authorProfileImage.image = image

                                    
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
    
    func displayTotalComments(key:String) {
        
        
        let commentsRef = databaseRef.child("comments").child(key)
        commentsRef.observeSingleEventOfType(.Value, withBlock:{ snapshot in
            
            if snapshot.exists() {
                self.commentsLabel.text = String(snapshot.childrenCount)
            }else {
                self.commentsLabel.text = "0"
            }
        })
    }
    
    func displayTotalLikes(key:String) {
        
        let authManager = AuthenticationManager.sharedInstance
        let currentUID = authManager.currentUser?.uid!
        
        let likesRef = databaseRef.child("likes").child(key)
        likesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                
                for snap in snapshot.children {
                    
                    if let uid = snap.value["uid"] as? String {
                        
                        if let unwrappedUID = currentUID {
                            if uid == unwrappedUID {
                                self.likesButton.enabled = false
                            }
                        }
                    }
                }
                
                self.likesLabel.text = String(snapshot.childrenCount)

            }else {
                self.likesLabel.text = "0"

            }
        })
    }
    
    func backAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func didTappedCommentButton(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let commentsController = storyboard.instantiateViewControllerWithIdentifier("CommentView") as? CommentsViewController
        
        commentsController?.feed = feed
        let navController = UINavigationController(rootViewController: commentsController!)
        self.presentViewController(navController, animated:true, completion: nil)
    }
    
    @IBAction func didTappedLikeButton(sender: AnyObject) {
    }
    
    
}
