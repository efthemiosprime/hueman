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
    
    var oldFeeds = [Feed]()
    var feeds = [Feed]()
    var filterController: FilterController?
    var huesFeedModel: HuesFeedViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        huesFeedModel = HuesFeedViewModel()

        self.navigationController?.navigationBar.topItem!.title = "hues feed"

        backItem = UIBarButtonItem(image: UIImage(named: "back-bar-item"), style: .Plain, target: self, action: #selector(HuesFeedViewController.hideSearchBar))
        
        searhItem = UIBarButtonItem(image: UIImage(named: "search-item-icon"), style: .Plain, target: self, action: #selector(HuesFeedViewController.showSearchBar))
        
        searhItem.imageInsets = UIEdgeInsetsMake(2, 18, -2, -18)
        
        filterItem = UIBarButtonItem(image: UIImage(named: "filter-bar-item"), style: .Plain, target: self, action: #selector(HuesFeedViewController.showFilter))
        filterItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0)
        menuItem = UIBarButtonItem(image: UIImage(named: "hamburger-bar-item"), style: .Plain, target: self, action: nil)
        
        
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        

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
        huesFeedModel.feetchFeeds({ feeds in
            self.feeds = feeds
            self.tableView.reloadData()
            self.removeAllOverlays()
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
        return feeds.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let feed = feeds[indexPath.row]
        
        let cell = feed.withImage == true ? tableView.dequeueReusableCellWithIdentifier(HuesFeedViewModel.CELL_IMAGE_IDENTIFIER, forIndexPath: indexPath) as! FeedImageTableViewCell : tableView.dequeueReusableCellWithIdentifier(HuesFeedViewModel.CELL_TEXT_IDENTIFIER, forIndexPath: indexPath) as! FeedTextTableViewCell
    
        if (feed.withImage == true)
        {
            let feedCell = cell as! FeedImageTableViewCell
            feedCell.feed = feed

            feedCell.showCommentsAction = { (cell) in
                
                self.performSegueWithIdentifier("ShowComments", sender: cell)

            }
            feedCell.showLikesAction = { cell in
                
                let authenticationManager = AuthenticationManager.sharedInstance

                if let feedUid = feed.uid {
                    if let userUid = authenticationManager.currentUser!.uid {
                        if feedUid != userUid {
                            let id = NSUUID().UUIDString
                            let likesRef = self.databaseRef.child("likes").child(feedCell.key).child(id)
                            
                            let newLike = Like(name: authenticationManager.currentUser!.name, uid: authenticationManager.currentUser!.uid, id: id)
                            likesRef.setValue(newLike.toAnyObject())
                            
                            
                            let newNotification: Notification = Notification(
                                fromUid: authenticationManager.currentUser!.uid,
                                id: NSUUID().UUIDString,
                                type: "liked",
                                feedKey: feed.key!)
                            
                            let notificationManager = NotificationsManager()
                            notificationManager.add(feed.uid!, notification: newNotification, completed: nil)
                        }
                    }
                }
                

            }

            
            feedCell.showPopover = { (cell) in
                let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("popoverID")
                popController.preferredContentSize = CGSizeMake(120, 160)
                popController.modalPresentationStyle = UIModalPresentationStyle.Popover
                // set up the popover presentation controller
                popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
                popController.popoverPresentationController?.delegate = self
                popController.popoverPresentationController?.sourceView = (cell as! FeedImageTableViewCell).popoverButton // button
                popController.popoverPresentationController?.sourceRect = (cell as! FeedImageTableViewCell).popoverButton.bounds
                                
                self.presentViewController(popController, animated: true, completion: nil)

            }
            
            
            huesFeedModel.displayTotalComments(feedCell.key, cell: feedCell)
            huesFeedModel.displayTotalLikes(feedCell.key, cell: feedCell)

            if let imageFeedURL = feeds[indexPath.row].imageURL {
                
                self.huesFeedModel.displayImageFeedWithURL(imageFeedURL, cell: feedCell)
                
            }
            
            
        }else {
            
            let feedCell = cell as! FeedTextTableViewCell

            feedCell.feed = feed
            huesFeedModel.displayTotalComments(feedCell.key, cell: feedCell)
            huesFeedModel.displayTotalLikes(feedCell.key, cell: feedCell)
            feedCell.showCommentsAction =  { (cell) in
                self.performSegueWithIdentifier("ShowComments", sender: cell)
            }
            
            feedCell.showLikesAction = { cell in
                let authenticationManager = AuthenticationManager.sharedInstance
                let id = NSUUID().UUIDString
                let likesRef = self.databaseRef.child("likes").child(feedCell.key).child(id)

                let newLike = Like(name: authenticationManager.currentUser!.name, uid: authenticationManager.currentUser!.uid, id: id)
                likesRef.setValue(newLike.toAnyObject())
            }
            
        }
        
        
        self.huesFeedModel.displayAuthorProfileImageWithURL(feed.uid!, cell: cell)

        
        switch feeds[indexPath.row].topic {
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
    
    // MARK: - Filter Option

    func onFilter(topics: [String])
    {
        
        feeds = topics.count > 0 ? huesFeedModel.oldFeeds.filter({topics.contains($0.topic!)}) : huesFeedModel.oldFeeds
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



