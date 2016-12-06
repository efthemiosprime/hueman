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

class HuesFeedViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    var searhItem: UIBarButtonItem!
    var filterItem: UIBarButtonItem!
    var menuItem: UIBarButtonItem!
    var backItem: UIBarButtonItem!
    var searchBarOpen: Bool = false
    
    let cellTextIdentifier = "huesfeedtextcell"
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var feeds = [Feed]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem!.title = "hues feed"

        backItem = UIBarButtonItem(image: UIImage(named: "back-bar-item"), style: .Plain, target: self, action: #selector(HuesFeedViewController.hideSearchBar))
        
        searhItem = UIBarButtonItem(image: UIImage(named: "search-item-icon"), style: .Plain, target: self, action: #selector(HuesFeedViewController.showSearchBar))
        
        searhItem.imageInsets = UIEdgeInsetsMake(2, 18, -2, -18)
        
        filterItem = UIBarButtonItem(image: UIImage(named: "filter-bar-item"), style: .Plain, target: self, action: nil)
        filterItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0)
        menuItem = UIBarButtonItem(image: UIImage(named: "hamburger-bar-item"), style: .Plain, target: self, action: nil)
        
        
        addNavigationItems()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        
        if revealViewController() != nil {
            menuItem.target = revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "hues feed"
        fetchFeeds()
    }

    
    
    func fetchFeeds() {
        showWaitOverlay()
        databaseRef.child("feeds").observeSingleEventOfType(.Value, withBlock: {
            feedsSnapshot in
            var newFeeds = [Feed]()
            for feed in feedsSnapshot.children {
                let newFeed = Feed(snapshot: feed as! FIRDataSnapshot)
                newFeeds.insert(newFeed, atIndex: 0)
            }
            
            self.feeds = newFeeds
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

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTextIdentifier, forIndexPath: indexPath) as! FeedTextTableViewCell
        cell.textFeedLabel.text = feeds[indexPath.row].text
        cell.textAuthorLabel.text = feeds[indexPath.row].author
        
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



