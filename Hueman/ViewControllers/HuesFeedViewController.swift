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

class HuesFeedViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    var searhItem: UIBarButtonItem!
    var filterItem: UIBarButtonItem!
    var menuItem: UIBarButtonItem!
    var backItem: UIBarButtonItem!
    var searchBarOpen: Bool = false
    
    let cellTextIdentifier = "huesfeedtextcell"
    let cellImageIdentifier = "huesfeedimagecell"
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    
    var storageRef: FIRStorage!{
        return FIRStorage.storage()
    }
    
    var feeds = [Feed]()
    var filterController: FilterController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem!.title = "hues feed"

        backItem = UIBarButtonItem(image: UIImage(named: "back-bar-item"), style: .Plain, target: self, action: #selector(HuesFeedViewController.hideSearchBar))
        
        searhItem = UIBarButtonItem(image: UIImage(named: "search-item-icon"), style: .Plain, target: self, action: #selector(HuesFeedViewController.showSearchBar))
        
        searhItem.imageInsets = UIEdgeInsetsMake(2, 18, -2, -18)
        
        filterItem = UIBarButtonItem(image: UIImage(named: "filter-bar-item"), style: .Plain, target: self, action: #selector(HuesFeedViewController.showFilter))
        filterItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0)
        menuItem = UIBarButtonItem(image: UIImage(named: "hamburger-bar-item"), style: .Plain, target: self, action: nil)
        
        
        addNavigationItems()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        fetchFeeds()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "hues feed"
        
        if revealViewController() != nil {
            menuItem.target = revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    
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
    
    
    func fetchFeeds() {
        
        showWaitOverlay()
        databaseRef.child("feeds").observeSingleEventOfType(.Value, withBlock: {
            feedsSnapshot in

            self.feeds  = feedsSnapshot.children.map({(feed) -> Feed in
                let newFeed: Feed = Feed(snapshot: feed as! FIRDataSnapshot)
                return newFeed
            }).reverse()
 
    
            self.tableView.reloadData()
            self.removeAllOverlays()
            
        }) {  error in
            print (error.localizedDescription)
        }
    }
    
    
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
        self.navigationController?.addChildViewController(filterController!)
        filterController?.view.frame = (self.tableView.superview?.frame)!
        self.navigationController?.view.addSubview((filterController?.view)!)
        filterController!.didMoveToParentViewController(self.navigationController)
        
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
        
        let cell = feed.withImage == true ? tableView.dequeueReusableCellWithIdentifier(cellImageIdentifier, forIndexPath: indexPath) as! FeedImageTableViewCell : tableView.dequeueReusableCellWithIdentifier(cellTextIdentifier, forIndexPath: indexPath) as! FeedTextTableViewCell
    
        if (feed.withImage == true) {
            (cell as! FeedImageTableViewCell).feed = feed
            (cell as! FeedImageTableViewCell).showCommentsAction = { (cell) in
                self.performSegueWithIdentifier("ShowComments", sender: nil)

            }


            storageRef.referenceForURL(feeds[indexPath.row].imageURL!).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                if error == nil {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if let data = data {
                            (cell as! FeedImageTableViewCell).feedImage.image = UIImage(data: data)
                        }
                    })
                    
                    
                }else {
                    print(error!.localizedDescription)
                }
            })
            
            let authorRef = FIRDatabase.database().reference().child("users").queryOrderedByChild("uid").queryEqualToValue(feed.uid)
                authorRef.observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
                    

                    if let photoURL = snapshot.value!["photoURL"] as? String {
                        self.storageRef.referenceForURL(photoURL).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                            if error == nil {
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    if let data = data {
                                        (cell as! FeedImageTableViewCell).authorProfileImage.image = UIImage(data: data)
                                    }
                                })
                                
                                
                            }else {
                                print(error!.localizedDescription)
                            }
                        })                    }
                    
                    
                }) { (error) in
                    print(error.localizedDescription)
                    
                }
                
            
            
            
            
        }else {
            (cell as! FeedTextTableViewCell).feed = feed
            
            let authorRef = FIRDatabase.database().reference().child("users").queryOrderedByChild("uid").queryEqualToValue(feed.uid)
            authorRef.observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
                
                
                if let photoURL = snapshot.value!["photoURL"] as? String {
                    self.storageRef.referenceForURL(photoURL).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                        if error == nil {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                if let data = data {
                                    (cell as! FeedTextTableViewCell).authorProfileImage.image = UIImage(data: data)
                                }
                            })
                            
                            
                        }else {
                            print(error!.localizedDescription)
                        }
                    })
                }
                
                
            }) { (error) in
                print(error.localizedDescription)
                
            }
            
        }
        
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
    

    
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
//    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10
//    }
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! FeedTextTableViewCell
//        
//        let textHeight = currentCell.textFeedLabel.frame.size.height
//        
//        return textHeight + 100
//    }

}



