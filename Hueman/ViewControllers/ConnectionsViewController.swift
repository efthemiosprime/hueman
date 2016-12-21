//
//  ConnectionsViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/21/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftOverlays

class ConnectionsViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var searhItem: UIBarButtonItem!
    var addItem: UIBarButtonItem!
    var menuItem: UIBarButtonItem!
    var backItem: UIBarButtonItem!
    
    var connections = [Connection]()
    var searchController: UISearchController!

    
    var searchBarOpen: Bool = false
    
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    
    var storageRef: FIRStorage!{
        return FIRStorage.storage()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        backItem = UIBarButtonItem(image: UIImage(named: "back-bar-item"), style: .Plain, target: self, action: #selector(ConnectionsViewController.didCancelSearch))
        
        searhItem = UIBarButtonItem(image: UIImage(named: "search-item-icon"), style: .Plain, target: self, action: #selector(ConnectionsViewController.showSearchBar))
        
        searhItem.imageInsets = UIEdgeInsetsMake(2, 18, -2, -18)

        addItem = UIBarButtonItem(image: UIImage(named: "add-item-icon"), style: .Plain, target: self, action: #selector(ConnectionsViewController.addConnections))
        addItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0)
        menuItem = UIBarButtonItem(image: UIImage(named: "hamburger-bar-item"), style: .Plain, target: self, action: nil)
        
        addNavigationItems()
        
        self.navigationController?.navigationBar.topItem!.title = "connections"
        
        
        
        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        

        if revealViewController() != nil {
            menuItem.target = revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
    }
    

    
    func fetchConnections() {
        let currentUser = FIRAuth.auth()?.currentUser
        let friendsRef = databaseRef.child("friends").child((currentUser?.uid)!)
        friendsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
        
            for con in snapshot.children {
                let connection = Connection(name: (con.value!["name"] as? String)!,
                    location: (con.value!["location"] as? String)!, imageURL: (con.value!["imageURL"] as? String)!, uid: (con.value!["uid"] as? String)!, friendship: (con.value!["friendship"] as? String)!)
                self.connections.append(connection)
            }
            
            self.tableView.reloadData()
            
            
        }) {(error) in
            print(error.localizedDescription)
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "connections"
        
        if revealViewController() != nil {
            menuItem.target = revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        fetchConnections()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if searchBarOpen {
            didCancelSearch()
        }
        
        if revealViewController() != nil {
            menuItem.target = nil
            menuItem.action = nil
            self.view.removeGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        connections.removeAll()
    }
    
    func addNavigationItems () {
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationItem.rightBarButtonItems = [addItem, searhItem]
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
    
    func didCancelSearch() {
        searchBarOpen = false
        hideNavigationItems()
        addNavigationItems()
        self.navigationItem.titleView = nil
    }
    
    func addConnections() {
        performSegueWithIdentifier("AddConnections", sender: nil);
    }
    
    // MARK: - Table View


    
    // MARK: - Search Controller
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    

    @IBAction func didTapSearch(sender: AnyObject) {
        self.searchBar.backgroundColor = UIColor.blackColor()

        self.navigationItem.titleView = self.searchBar
        
    }


//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let destinationProfileController = segue.destinationViewController as? ConnectionProfileViewController {
//            
//        }
//    }
    
    
}


extension ConnectionsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CONNECTION_CELL_IDENTIFIER, forIndexPath: indexPath) as! ConnectionCell
        cell.connection = connections[indexPath.row]
        
        storageRef.referenceForURL(connections[indexPath.row].imageURL!).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue(), {
                    if let data = data {
                        cell.connectionImage.image = UIImage(data: data)
                    }
                })
                
                
            }else {
                print(error!.localizedDescription)
            }
        })
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        performSegueWithIdentifier("showConnection", sender: indexPath)
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.selected == true {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}

extension ConnectionsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections.count
    }
}
