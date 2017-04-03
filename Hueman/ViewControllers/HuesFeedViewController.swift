//
//  HuesFeedViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import MessageUI
import SwiftOverlays

class HuesFeedViewController: UITableViewController, UIPopoverPresentationControllerDelegate, FilterControllerDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var searhItem: UIBarButtonItem!
    var filterItem: UIBarButtonItem!
    var menuItem: UIBarButtonItem!
    var backItem: UIBarButtonItem!
    var searchBarOpen: Bool = false
    
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    
    var storageRef: FIRStorage!{
        return FIRStorage.storage()
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()

    
    var filterController: FilterController?
    var huesFeedModel: HuesFeedViewModel!
    
    var searchIsBarOpen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        huesFeedModel = HuesFeedViewModel()
        searchBar.delegate = self

        self.navigationController?.navigationBar.topItem!.title = "hues feed"

        backItem = UIBarButtonItem(image: UIImage(named: "back-bar-item"), style: .Plain, target: self, action: #selector(HuesFeedViewController.hideSearchBar))
        
        searhItem = UIBarButtonItem(image: UIImage(named: "search-item-icon"), style: .Plain, target: self, action: #selector(HuesFeedViewController.showSearchBar))
        
        searhItem.imageInsets = UIEdgeInsetsMake(2, 18, -2, -18)
        
        filterItem = UIBarButtonItem(image: UIImage(named: "filter-bar-item"), style: .Plain, target: self, action: #selector(HuesFeedViewController.showFilter))
        filterItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0)
        menuItem = UIBarButtonItem(image: UIImage(named: "hamburger-bar-item"), style: .Plain, target: self, action: nil)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        if let viewControllers = self.tabBarController?.parentViewController?.parentViewController?.childViewControllers {
            for viewController in viewControllers {
                print("controller: \(viewController)")
            }
        }

        addNavigationItems()


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "hues feed"


        if revealViewController() != nil {
            menuItem.target = revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        showWaitOverlay()
        
        huesFeedModel.fetchConnections({
            
            self.huesFeedModel.feetchFeeds({ errorString in
                
                if errorString == "Empty" {
                    let emptyBackground = UIImage(named: "huesfeed-empty")
                    let emptyView = UIImageView(image: emptyBackground)
                    emptyView.contentMode = .ScaleAspectFill
                    self.tableView.backgroundView = emptyView
                }
                
                self.removeAllOverlays()
                
                },
                completion: { feeds in
                    
                    if let savedFilters = self.defaults.objectForKey("savedFilters") as? [String] {
                        self.onFilter(savedFilters)
                        self.removeAllOverlays()

                    }else {
                        self.tableView.backgroundView = nil
                        self.tableView.reloadData()
                        self.removeAllOverlays()
                    }
                    

            })
            
            
        },
        onError: { errorString in
            if errorString == "Empty" {
                print("empty")
                let emptyBackground = UIImage(named: "huesfeed-empty")
                let emptyView = UIImageView(image: emptyBackground)
                emptyView.contentMode = .ScaleAspectFill
                self.tableView.backgroundView = emptyView
                
                self.removeAllOverlays()

                
                self.huesFeedModel.feetchFeeds({ errorString in
                    print("error string \(errorString)")
                    
                    self.removeAllOverlays()
                    
                },
                completion: { feeds in
                    print("completion \(feeds.count)")
                    if feeds.count > 0 {
                        self.tableView.backgroundView = nil
                        self.tableView.reloadData()
                        self.removeAllOverlays()
                    }

                })
            }
        })

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if searchBarOpen {
            hideSearchBar()
        }
        
        if revealViewController() != nil {
            menuItem.target = nil
            menuItem.action = nil
            self.view.removeGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowComments" {
            
            
            if let navController = segue.destinationViewController as? UINavigationController {
                
                
                
                if let commentsViewController = navController.topViewController as? CommentsViewController {
                    
                    let selectedFeed: Feed?
                    
                    if sender is FeedImageTableViewCell  {
                        selectedFeed = (sender as! FeedImageTableViewCell).feed
                    }else {
                        selectedFeed = (sender as! FeedTextTableViewCell).feed
                        
                    }
                    
                    commentsViewController.feed = selectedFeed

                }
        
            }
        }
        
        
        if segue.identifier == "EditPost" {
                        
            let createPostController = segue.destinationViewController as! CreatePostViewController
            createPostController.mode = "edit"

        }
    }
    

    
    // MARK: - Popover
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }



    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchIsBarOpen && searchBar.text != "" && huesFeedModel.filteredFeeds.count > 0 {
            return huesFeedModel.filteredFeeds.count
        }
        return huesFeedModel.feeds.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let feed = ( searchIsBarOpen && searchBar.text != "" && huesFeedModel.filteredFeeds.count > 0) ? huesFeedModel.filteredFeeds[indexPath.row] : huesFeedModel.feeds[indexPath.row]
        
        
        let cell = feed.withImage == true ? tableView.dequeueReusableCellWithIdentifier(HuesFeedViewModel.CELL_IMAGE_IDENTIFIER, forIndexPath: indexPath) as! FeedImageTableViewCell : tableView.dequeueReusableCellWithIdentifier(HuesFeedViewModel.CELL_TEXT_IDENTIFIER, forIndexPath: indexPath) as! FeedTextTableViewCell
    
        if (feed.withImage == true)
        {
            let feedCell = cell as! FeedImageTableViewCell
            feedCell.feed = feed
            
            let authenticationManager = AuthenticationManager.sharedInstance


            feedCell.showCommentsAction = { (cell) in
                
                self.performSegueWithIdentifier("ShowComments", sender: cell)

            }
            
            
            feedCell.flagAction = {
                
                let userUid = authenticationManager.currentUser!.uid!
                let flagsRef = self.databaseRef.child("flags").child(feedCell.key).child(userUid)
                
                if feedCell.flagButton.selected == false {
                    let newFlag = Flag(name: authenticationManager.currentUser!.name, uid: userUid)
                    flagsRef.setValue(newFlag.toAnyObject()) { (error, ref) in
                        if error != nil {
                            print(error?.description)
                        }else {
                            feedCell.flagButton.selected = true
                            feedCell.flagButton.backgroundColor = UIColor.clearColor()
                            self.huesFeedModel.checkFeedForDeletion(feedCell.feed!.key!, deleteIt: {
                                self.deletePost(feedCell.feed!, indexPath: indexPath)
                            })
                        }
                        
                    }
                }else {
                    flagsRef.removeValueWithCompletionBlock({ (error, ref) in
                        if error != nil {
                            print(error?.description)
                        }else {
                            feedCell.updateFlagButton((feedCell.feed?.topic)! )
                        }
                    })
                }
                
                
            }
            
            
            feedCell.showLikesAction = { cell in
                let authenticationManager = AuthenticationManager.sharedInstance

                if feedCell.likesButton.selected == false {
                    if let fedUid = feed.uid {
                        if let userUid = authenticationManager.currentUser?.uid {
                            let likesRef = self.databaseRef.child("likes").child(feedCell.key).child(userUid)
                            
                            
                            if fedUid != userUid {
                                
                                
                                let newLike = Like(name: authenticationManager.currentUser!.name, uid: authenticationManager.currentUser!.uid)
                                likesRef.setValue(newLike.toAnyObject())
                                
                                let newNotification: Notification = Notification(
                                    fromUid: authenticationManager.currentUser!.uid,
                                    id: NSUUID().UUIDString,
                                    type: "liked",
                                    feedTopic: feed.topic!,
                                    feedKey: feed.key!)
                                
                                
                                let notificationManager = NotificationsManager()
                                notificationManager.add(feed.uid!, notification: newNotification, completed: nil)
                                
                                
                                feedCell.likesButton.selected = true
                                feedCell.likesLabel.text = String(UInt(feedCell.likesLabel.text!)! + 1)
                                
                            }
                            
                        }
                    }
                }else {
                    let likesRef = self.databaseRef.child("likes").child(feedCell.key).child(authenticationManager.currentUser!.uid!)
                    likesRef.removeValueWithCompletionBlock({(error, referer) in
                        if error != nil {
                            print(error?.description)
                        }else {
                            dispatch_async(dispatch_get_main_queue(), {
                                feedCell.likesButton.selected = false
                                feedCell.likesLabel.text = String(UInt(feedCell.likesLabel.text!)! - 1)
                                
                            })
                        }
                    })
                }
            }

            
            feedCell.showPopover = { (cell) in
                
                var popupType: String?
                indexPath
                if let unWrappedUserUid = authenticationManager.currentUser?.uid, let unWrappedFeedUid = feedCell.feed?.uid {
                    popupType = (unWrappedUserUid == unWrappedFeedUid) ? "PopoverEdit" : "PopoverReport"
                    
                }
                let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(popupType!) as! PopoverViewController
                popController.delegate = self
                popController.indexPath = indexPath
                popController.preferredContentSize = CGSizeMake(120, (popupType!) == "PopoverEdit" ? 115 : 48)
                popController.modalPresentationStyle = UIModalPresentationStyle.Popover
                // set up the popover presentation controller
                popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
                popController.popoverPresentationController?.delegate = self
                popController.popoverPresentationController?.sourceView = (cell as! FeedImageTableViewCell).popoverButton // button
                popController.popoverPresentationController?.sourceRect = (cell as! FeedImageTableViewCell).popoverButton.bounds
                popController.feed = feed
                
                self.presentViewController(popController, animated: true, completion: nil)

            }
            
            feedCell.showAuthor = { cell in
                
                if let unwrappedUid = (cell as! FeedImageTableViewCell).feed?.uid {
                    
                    let userRef = self.databaseRef.child("users").child(unwrappedUid )
                    userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        if snapshot.exists() {
                            var profileViewIsPresent = false
                            
                        
                            if let viewControllers = self.tabBarController?.parentViewController?.childViewControllers {
                                for viewController in viewControllers {
                                    print("controller: \(viewController)")
                                    if(viewController is ProfileViewController) {
                                        profileViewIsPresent = true
                                        continue
                                    }
                                } 
                            }
                            
                            if profileViewIsPresent == false {
                                
                                let user = User(snapshot: snapshot)
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.showAuthorProfile(user)
                                })
                            }
                            
                        }
                        
                    })
                    
                }
            }
            
            
            huesFeedModel.displayTotalComments(feedCell.key, cell: feedCell)
            huesFeedModel.displayTotalLikes(feedCell.key, cell: feedCell)
            
            
            if searchIsBarOpen && searchBar.text != "" && huesFeedModel.filteredFeeds.count > 0 {
                if let imageFeedURL = huesFeedModel.filteredFeeds[indexPath.row].imageURL {
                    
                    self.huesFeedModel.displayImageFeedWithURL(imageFeedURL, cell: feedCell)
                    
                }
            }else {
                if let imageFeedURL = huesFeedModel.feeds[indexPath.row].imageURL {
                    
                    self.huesFeedModel.displayImageFeedWithURL(imageFeedURL, cell: feedCell)
                    
                }
            }
            
            


            
            
        }else {
            let feedCell = cell as! FeedTextTableViewCell
            let authenticationManager = AuthenticationManager.sharedInstance

            feedCell.feed = feed
            huesFeedModel.displayTotalComments(feedCell.key, cell: feedCell)
            huesFeedModel.displayTotalLikes(feedCell.key, cell: feedCell)
            feedCell.showCommentsAction =  { (cell) in
                self.performSegueWithIdentifier("ShowComments", sender: cell)
            }
            
            feedCell.flagAction = {
            
                let userUid = authenticationManager.currentUser!.uid!
                let flagsRef = self.databaseRef.child("flags").child(feedCell.key).child(userUid)
                
                if feedCell.flagButton.selected == false {
                    let newFlag = Flag(name: authenticationManager.currentUser!.name, uid: userUid)
                    flagsRef.setValue(newFlag.toAnyObject()) { (error, ref) in
                        if error != nil {
                            print(error?.description)
                        }else {
                           // feedCell.flagButton.selected = true
                            feedCell.flagButton.backgroundColor = UIColor.clearColor()
                            self.huesFeedModel.checkFeedForDeletion(feedCell.feed!.key!)
                        }
                        
                    }
                }else {
                    flagsRef.removeValueWithCompletionBlock({ (error, ref) in
                        if error != nil {
                            print(error?.description)
                        }else {
                            feedCell.updateFlagButton((feedCell.feed?.topic)! )
                        }
                    })
                }

                
            }
            
            feedCell.showLikesAction = { cell in

                if feedCell.likesButton.selected == false {
                    if let fedUid = feed.uid {
                        if let userUid = authenticationManager.currentUser?.uid {
                            let likesRef = self.databaseRef.child("likes").child(feedCell.key).child(userUid)

                            
                            if fedUid != userUid {

                                
                                let newLike = Like(name: authenticationManager.currentUser!.name, uid: authenticationManager.currentUser!.uid)
                                likesRef.setValue(newLike.toAnyObject()) { (error, ref) in
                                    if error != nil {
                                        print(error?.description)
                                    }else {
                                        let newNotification: Notification = Notification(
                                            fromUid: authenticationManager.currentUser!.uid,
                                            id: NSUUID().UUIDString,
                                            type: "liked",
                                            feedTopic: feed.topic!,
                                            feedKey: feed.key!)
                                        
                                        
                                        let notificationManager = NotificationsManager()
                                        notificationManager.add(feed.uid!, notification: newNotification, completed: nil)
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), {
                                            feedCell.likesButton.selected = true
                                            feedCell.likesLabel.text = String(UInt(feedCell.likesLabel.text!)! + 1)
                                            
                                        })
                                        
                                    }
                                }
                                

                                


                            }
                            
                        }
                    }
                }else {
                    let likesRef = self.databaseRef.child("likes").child(feedCell.key).child(authenticationManager.currentUser!.uid!)
                    likesRef.removeValueWithCompletionBlock({(error, referer) in
                        if error != nil {
                            print(error?.description)
                        }else {
                            dispatch_async(dispatch_get_main_queue(), {
                                feedCell.likesButton.selected = false
                                feedCell.likesLabel.text = String(UInt(feedCell.likesLabel.text!)! - 1)

                            })
                        }
                    })

                }
                


            }
            
            feedCell.showAuthor = { cell in
            

                if let unwrappedUid = (cell as! FeedTextTableViewCell).feed?.uid {
                    
                    let userRef = self.databaseRef.child("users").child(unwrappedUid )
                    userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        if snapshot.exists() {
                            
                            var profileViewIsPresent = false
                            
                            
                            if let viewControllers = self.tabBarController?.parentViewController?.childViewControllers {
                                for viewController in viewControllers {
                                    if(viewController is ProfileViewController) {
                                        profileViewIsPresent = true
                                        continue
                                    }
                                }
                            }
                            
                            if profileViewIsPresent == false {
                                
                                let user = User(snapshot: snapshot)
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.showAuthorProfile(user)
                                })
                            }
                            
                        }
                        
                    })
                    
                }
            }
            
            feedCell.showPopover = { (cell) in
                
                var popupType: String?
                
                if let unWrappedUserUid = authenticationManager.currentUser?.uid, let unWrappedFeedUid = feedCell.feed?.uid {
                    popupType = (unWrappedUserUid == unWrappedFeedUid) ? "PopoverEdit" : "PopoverReport"
                    
                }
                
                let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(popupType!) as! PopoverViewController
                popController.delegate = self
                popController.indexPath = indexPath
                popController.preferredContentSize = CGSizeMake(120, (popupType!) == "PopoverEdit" ? 115 : 48)
                popController.modalPresentationStyle = UIModalPresentationStyle.Popover
                // set up the popover presentation controller
                popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
                popController.popoverPresentationController?.delegate = self
                popController.popoverPresentationController?.sourceView = (cell as! FeedTextTableViewCell).popoverButton // button
                popController.popoverPresentationController?.sourceRect = (cell as! FeedTextTableViewCell).popoverButton.bounds
                popController.feed = feed

                self.presentViewController(popController, animated: true, completion: nil)
                
            }
            
            
            
        }
        
        
        self.huesFeedModel.displayAuthorProfileImageWithURL(feed.uid!, cell: cell)


        let whichFeeds = (searchIsBarOpen && searchBar.text != "" && huesFeedModel.filteredFeeds.count > 0) ? huesFeedModel.filteredFeeds : huesFeedModel.feeds
        switch whichFeeds[indexPath.row].topic {
        case Topic.Wanderlust:
            cell.contentView.backgroundColor = UIColor.UIColorFromRGB(Color.Wanderlust)

            break;
        case Topic.DailyHustle:
            cell.contentView.backgroundColor = UIColor.UIColorFromRGB(Color.DailyHustle)
            break;
        case Topic.Health:
            cell.contentView.backgroundColor = UIColor.UIColorFromRGB(Color.Health)
            break;
        case Topic.RayOfLight:
            cell.contentView.backgroundColor = UIColor.UIColorFromRGB(Color.RayOfLight)
            break;
            
        case Topic.OnMyPlate:
            cell.contentView.backgroundColor = UIColor.UIColorFromRGB(Color.OnMyPlate)
            break;
            
        default:
            cell.contentView.backgroundColor = UIColor.UIColorFromRGB(Color.RelationshipMusing)
        }
        
        return cell
    }
    
    
    func showAuthorProfile(user: User) {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileController = storyboard.instantiateViewControllerWithIdentifier("ProfileView") as? ProfileViewController
        profileController?.user = user
        
        self.tabBarController?.parentViewController!.addChildViewController(profileController!)
        profileController?.view.frame =  CGRectMake(screenWidth, 0.0, screenWidth, screenHeight)
        self.tabBarController?.parentViewController!.view.addSubview((profileController?.view)!)
        profileController!.didMoveToParentViewController(self.tabBarController?.parentViewController)
    }
    
    // MARK: - Filter Option

    func onFilter(topics: [String])
    {
        
        if searchIsBarOpen && searchBar.text != "" && huesFeedModel.filteredFeeds.count > 0 {
            huesFeedModel.filteredFeeds = topics.count > 0 ? huesFeedModel.oldFeeds.filter({topics.contains($0.topic!)}) : huesFeedModel.oldFeeds

        }else {
            huesFeedModel.feeds = topics.count > 0 ? huesFeedModel.oldFeeds.filter({topics.contains($0.topic!)}) : huesFeedModel.oldFeeds
        }
        
        self.tableView.reloadData()
        
    }
    
    // Mark: - 
    func addNavigationItems () {
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationItem.rightBarButtonItems = [filterItem, searhItem]
    }
    
    func hideNavigationItems () {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = nil
    }
    
    func showSearchBar() {
        searchBarOpen = true
        hideNavigationItems()
        self.navigationItem.leftBarButtonItem = backItem
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    func hideSearchBar() {
        searchBarOpen = false
        hideNavigationItems()
        addNavigationItems()
        searchBar.text = ""
        huesFeedModel.filteredFeeds.removeAll()
        self.tableView.reloadData()
        self.navigationItem.titleView = nil
    }
    
    func showFilter() {
        filterController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FilterID") as? FilterController
        filterController?.delegate = self
        self.navigationController?.addChildViewController(filterController!)
        filterController?.view.frame = (self.tableView.superview?.frame)!
        self.navigationController?.view.addSubview((filterController?.view)!)
        filterController!.didMoveToParentViewController(self.navigationController)
        
    }
    

}

extension HuesFeedViewController: PopoverDelegate, MFMailComposeViewControllerDelegate {
    func editPost(feed: Feed) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var storedEntry = [String: AnyObject]()
        storedEntry["postInput"] = feed.text
        
        if let feedKey = feed.key  {
            storedEntry["key"] = feedKey
        }
        
        if feed.withImage != nil {
            if let imageURL = feed.imageURL where !(feed.imageURL?.isEmpty)! {
                storedEntry["imageURL"] = imageURL
            }
        }
        
        if let topic = feed.topic {
            storedEntry["topic"] = topic
            switch topic {
            case Topic.Wanderlust:
                storedEntry["icon"] = Icon.Wanderlust
                storedEntry["color"] = Color.Wanderlust
                break
            case Topic.DailyHustle:
                storedEntry["icon"] = Icon.DailyHustle
                storedEntry["color"] = Color.DailyHustle
                break
            case Topic.Health:
                storedEntry["icon"] = Icon.Health
                storedEntry["color"] = Color.Health
                break
                
            case Topic.OnMyPlate:
                storedEntry["icon"] = Icon.OnMyPlate
                storedEntry["color"] = Color.OnMyPlate
                break
                
            case Topic.RelationshipMusing:
                storedEntry["icon"] = Icon.RelationshipMusing
                storedEntry["color"] = Color.RelationshipMusing
                break
            default:
                storedEntry["icon"] = Icon.RayOfLight
                storedEntry["color"] = Color.RayOfLight
            }
            
            
            defaults.setObject(storedEntry, forKey: "storedEntry")
            defaults.synchronize()
        }

        
        self.performSegueWithIdentifier("EditPost", sender: nil)
    }
    
    func reportPost(feed: Feed) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["report@huemanapp.com"])
            mailVC.setSubject("Report feed")
            mailVC.setMessageBody("Report this feed", isHTML: false)
            presentViewController(mailVC, animated: true, completion: nil)
            
        }else {
            // show failure alert
            print("error")
        }

        
    }
    
    func deletePost(feed: Feed, indexPath: NSIndexPath) {
        
        
        
    
        
        huesFeedModel.deleteFeed(feed.key!, completion:{
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            self.huesFeedModel.feeds.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
            self.tableView.endUpdates()
        })

        
        
    

        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
//        switch result.value {
//        case MFMailComposeResultCancelled.value:
//            print("Mail cancelled")
//        case MFMailComposeResultSaved.value:
//            println("Mail saved")
//        case MFMailComposeResultSent.value:
//            println("Mail sent")
//        case MFMailComposeResultFailed.value:
//            println("Mail sent failure: %@", [error.localizedDescription])
//        default:
//            break
//        }
        
        
        controller.dismissViewControllerAnimated(true, completion: nil)

    }
    

}



// MARK: - Search Controller
extension HuesFeedViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchIsBarOpen = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchIsBarOpen = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchIsBarOpen = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchIsBarOpen = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        huesFeedModel.filterFeeds(searchText)
        self.tableView.reloadData()
 
    }
    
    
}



