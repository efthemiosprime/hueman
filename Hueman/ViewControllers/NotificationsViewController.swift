//
//  NotificationsViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class NotificationsViewController: UITableViewController {

    var menuItem: UIBarButtonItem!
    var viewModel: NotificationsViewModel!
    var currentUser: User?

    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem!.title = "notifications"
        
        menuItem = UIBarButtonItem(image: UIImage(named: "hamburger-bar-item"), style: .Plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = menuItem

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
//        self.tabBarController?.tabBar.items![1].badgeValue = "1"
        
        viewModel = NotificationsViewModel()

        
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentUser == nil {
            currentUser = AuthenticationManager.sharedInstance.currentUser
        }
        
        self.navigationController?.navigationBar.topItem!.title = "notifications"
        
        if revealViewController() != nil {
            menuItem.target = revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        

        viewModel.load({ items in
            //self.data = items.reverse()
            print("xx \(self.viewModel.data.count)" )
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.backgroundView = nil
                self.tableView.reloadData()
            })
        },
        onerror: { errorString in
            print("xx \(self.viewModel.data.count)" )

            if errorString == "Empty" {
                let emptyBackground = UIImage(named: "notifications-empty")
                let emptyView = UIImageView(image: emptyBackground)
                emptyView.contentMode = .ScaleAspectFill
                self.tableView.backgroundView = emptyView
            }

        }
        
        )
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 3)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.clearBadge()
        })

    }
    
    func clearBadge () {
        let notificationManager = NotificationsManager()
        notificationManager.deleteNotifications({

        })
        
        self.tabBarController?.tabBar.items![1].badgeValue = nil

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if revealViewController() != nil {
            menuItem.target = nil
            menuItem.action = nil
            self.view.removeGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.reset()
    }
    
    
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "ShowComments" {
//            
//            
//            if let navController = segue.destinationViewController as? UINavigationController {
//                
//                
//                
//                if let commentsViewController = navController.topViewController as? CommentsViewController {
//                    
//                    let selectedFeed: Feed?
//                    commentsViewController.feed = selectedFeed
//                    
//                }
//                
//            }
//        }
//    }
//    

    

    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.sectionTitles.count
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return nData[section].count
        print(viewModel.data[section].count)
        return viewModel.data[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return viewModel.sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.UIColorFromRGB(0x666666)
        
        let title = UILabel()
        title.font = UIFont(name: Font.SofiaProRegular, size: 12)!
        title.textColor = UIColor.whiteColor()
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font=title.font
        header.textLabel?.textColor=title.textColor
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let notificationItem = viewModel.data[indexPath.section][indexPath.row]
        
        let cell = notificationItem.type == "request" ? tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! AddUserCell : tableView.dequeueReusableCellWithIdentifier("NotificationCell", forIndexPath: indexPath) as! NotificationCell

        if notificationItem.type == "request" {
            let connectionRequestCell = cell as! AddUserCell
            
            var location: UserLocation?
            
            if let locString = notificationItem.location {
                location = UserLocation(location: locString)

            }else {
                location = UserLocation(location: "")

            }
            let user = User(name: notificationItem.name, location: location!, userId: notificationItem.uid!, photoURL: notificationItem.photoURL)
            connectionRequestCell.user = user
            if self.viewModel.requests.count > 0 {
                connectionRequestCell.addUserAction = { (cell) in
                    
                    self.tableView.beginUpdates()
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    self.viewModel.data[0].removeAtIndex(indexPath.row)
                    
                    
                    let requestRef = self.databaseRef.child("requests").child((self.currentUser?.uid)!)
                    requestRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        
                        if snapshot.exists() {
                            
                            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                
                                
                                
                                for child in result {
                                    
                                    let friendshipKey = child.value!["id"] as! String
                                    let friendshipRequester = child.value!["requester"] as! String
                                    let friendshipRecipient = child.value!["recipient"] as! String
                                    let friendshipRef = self.databaseRef.child("friendships").child(friendshipKey)
                                    
                                    friendshipRef.updateChildValues(["status":Friendship.Accepted])
                                    
                                    // friendshipRecipient == currentUserUid
                                    // Recipient is the current user
                                    
                                    
                                    let userRef = self.databaseRef.child("users").child(friendshipRequester)
                                    userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                                        if snapshot.exists() {
                                            var requester = Connection(snapshot: snapshot)
                                            requester.friendship = friendshipKey
                                            
                                            if let unwrappedLocation = self.currentUser?.location {
                                                var recipient = Connection(name: self.currentUser!.name, location: unwrappedLocation, imageURL: self.currentUser!.photoURL!, uid: self.currentUser!.uid)
                                                recipient.friendship = friendshipKey
                                                
                                                self.databaseRef.child("friends").child(friendshipRequester).child(recipient.uid).setValue(recipient.toAnyObject())
                                                self.databaseRef.child("friends").child(friendshipRecipient).child(requester.uid).setValue(requester.toAnyObject())
                                            }
                                            
                                            
                                            
                                            
                                            
                                        }
                                    }) { error in
                                        print(error.localizedDescription)
                                    }
                                    
                                }
                                
                                requestRef.removeValue()
                                
                                
                            }
                            
                            
                        } else {
                            print("no results")
                        }
                        
                        
                    }) {(error) in
                        
                        print(error.localizedDescription)
                    }
                    
                    
                    self.tableView.reloadData()
                    self.tableView.endUpdates()
                }
            }

        }else {
            (cell as! NotificationCell).data = viewModel.data[indexPath.section][indexPath.row]

        }
        
        

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedNotification: NotificationItem = viewModel.data[indexPath.section][indexPath.row]
        viewModel.getFeed(selectedNotification.key, result: {
            feed in
                
            
            if selectedNotification.type == "commented" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let commentsController = storyboard.instantiateViewControllerWithIdentifier("CommentView") as? CommentsViewController
                
                commentsController?.feed = feed
                let navController = UINavigationController(rootViewController: commentsController!)
                self.presentViewController(navController, animated:true, completion: nil)
                //                    self.tabBarController?.selectedIndex = 2
            }else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let feedController = storyboard.instantiateViewControllerWithIdentifier("FeedView") as? FeedController
                
                feedController?.feed = feed
                let navController = UINavigationController(rootViewController: feedController!)
                self.presentViewController(navController, animated:true, completion: nil)
            }

        })

        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     
     UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: Font.SofiaProRegular, size: 20)!]

    */

}
