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
    @IBOutlet weak var activityIndicator: ActivityIndicator!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
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

        commentInput.delegate = self
        commentInput.becomeFirstResponder()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(CommentsViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .None
        
        
        viewModel.fetchComments(feed , completion: {
            dispatch_async(dispatch_get_main_queue(), {
               // self.activityIndicator.hide()
                self.tableView.reloadData()
            })
        })
    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "comments"
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight)
        }) { (Finished) -> Void in
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.commentsRef.removeAllObservers()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height

        bottomConstraint.constant = keyboardHeight
        self.view.layoutIfNeeded()
    }
    
    
    @IBAction func didTappedBackButton(sender: AnyObject) {
        commentInput.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBAction func didTappedPost(sender: AnyObject) {
        
        if !(commentInput.text?.isEmpty)! ?? true {
            if let inputText = commentInput.text {
                if feed != nil {
                    viewModel.postComment(feed, comment: inputText)
                }
            }
        }
    }
    
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(viewModel.cellID, forIndexPath: indexPath) as! CommentCell
        
        cell.comment = viewModel.comments[indexPath.row]
        cell.deleteAction = { key in
            
            if let feedKey = self.feed.key {
                let commentRef = self.dataBaseRef.child("comments/\(feedKey)").queryOrderedByChild(key)
                commentRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
                    if snapshot.exists() {
                        let comment = self.dataBaseRef.child("comments/\(feedKey)/\(key)")
                        comment.removeValue()
                        self.tableView.beginUpdates()

                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                        self.viewModel.comments.removeAtIndex(indexPath.row)
                        
                        self.tableView.reloadData()
                        self.tableView.endUpdates()
                        

                        
                    }
                })
                
            }

        }
    
        return cell
    }
}


extension CommentsViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Moving the View up after the Keyboard appears
    func textFieldDidBeginEditing(textField: UITextField) {
        //animateView(true, moveValue: 80)
        
        
    }
    
    
    // Moving the View down after the Keyboard disappears
    func textFieldDidEndEditing(textField: UITextField) {
        // animateView(false, moveValue: 80)
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 250
    }
    
    
}

