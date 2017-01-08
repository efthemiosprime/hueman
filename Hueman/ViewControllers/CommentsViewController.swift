//
//  CommentsViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/11/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftOverlays

class CommentsViewController: UIViewController {
    
        
    @IBOutlet weak var textViewContainer: UIView!
    @IBOutlet weak var commentInput: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    var commentsRef: FIRDatabaseQuery!
    

    var viewModel: CommentsViewModel!
    var feed: Feed!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CommentsViewModel()
           // self.navigationController?.navigationBar.topItem!.title = "comments"
           // self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        commentInput.becomeFirstResponder()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(CommentsViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        notificationCenter.addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

        self.tableView.separatorStyle = .None
        print("feed id \(feed.key)")
        loadComments()
    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "comments"
            

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        commentsRef.removeAllObservers()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
       //bottomHeight.constant = keyboardHeight
       // self.view.setNeedsLayout()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        print(keyboardHeight)
        textViewContainer.frame = CGRectMake(0, screenHeight - (keyboardHeight + 102), screenWidth, textViewContainer.frame.size.height)
        self.view.setNeedsLayout()
    }
    
    func postComment() {
        
        
        
        if !(commentInput.text?.isEmpty)! ?? true {
            if let inputText = commentInput.text {
                let authManager = AuthenticationManager.sharedInstance
                let uuid = NSUUID().UUIDString
                let newComment = Comment(name: authManager.currentUser!.name, text: inputText, id: uuid, imageURL: authManager.currentUser!.photoURL!)
               
                
                if feed != nil {
                    let commentRef = dataBaseRef.child("comments").child(feed.key!).childByAutoId()
                    commentRef.setValue(newComment.toAnyObject())
                    commentInput.text = ""
                    
                    print(feed.uid)
                    print(authManager.currentUser?.uid)
                    
                    if let feedUid = feed.uid {
                        if let userUid = authManager.currentUser!.uid {
                            if (feedUid != userUid) {
                                                        let newNotification: Notification = Notification(
                                                            fromUid: authManager.currentUser!.uid,
                                                            id: NSUUID().UUIDString,
                                                            type: "commented",
                                                            feedKey: feed.key!)
                                
                                                        let notificationManager = NotificationsManager()
                                                        notificationManager.add(feed.uid!, notification: newNotification, completed: nil)
                            }
                        }
                    }

    
                }
            }
        }
    }
    
    func loadComments() {
        
        showWaitOverlay()
        
        commentsRef = dataBaseRef.child("comments").child(feed.key!)
        commentsRef.observeEventType(.Value, withBlock:{ snapshot in
            
            let comments: [Comment]  = snapshot.children.map({(comment) -> Comment in
                let newComment: Comment = Comment(snapshot: comment as! FIRDataSnapshot)
                return newComment
            }).reverse()
            
            
            self.viewModel.comments = comments
            
            dispatch_async(dispatch_get_main_queue(), {
                self.removeAllOverlays()
                self.tableView.reloadData()
            })
        })
    }
    
    func loadAuthorProfileImage() {
        commentsRef = dataBaseRef.child("comments").child(feed.key!)

    }
    
    @IBAction func didTappedBackButton(sender: AnyObject) {
        commentInput.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBAction func didTappedPost(sender: AnyObject) {
        postComment()
    }
        
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(viewModel.cellID, forIndexPath: indexPath) as! CommentCell
        
        cell.comment = viewModel.comments[indexPath.row]
    
        return cell
    }
}


extension CommentsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 96
    }
    
}

