//
//  ConnectionsViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/21/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//
// http://shrikar.com/swift-ios-tutorial-uisearchbar-and-uisearchbardelegate/
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftOverlays

class ConnectionsViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searhItem: UIBarButtonItem!
    var addItem: UIBarButtonItem!
    var menuItem: UIBarButtonItem!
    var backItem: UIBarButtonItem!
    var addIconWithBadge: UIImage!
    var addIconNoBadge: UIImage!
    
    var searchIsBarOpen: Bool = false
    
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    
    var storageRef: FIRStorage!{
        return FIRStorage.storage()
    }
    
    var connectionsModel: ConnectionsViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        connectionsModel = ConnectionsViewModel()

        addIconWithBadge = UIImage(named: "add-item-badge-icon")
        addIconNoBadge = UIImage(named: "add-item-icon")
        
        backItem = UIBarButtonItem(image: UIImage(named: "back-bar-item"), style: .Plain, target: self, action: #selector(ConnectionsViewController.didCancelSearch))
        
        searhItem = UIBarButtonItem(image: UIImage(named: "search-item-icon"), style: .Plain, target: self, action: #selector(ConnectionsViewController.showSearchBar))
        
        searhItem.imageInsets = UIEdgeInsetsMake(2, 18, -2, -18)

        addItem = UIBarButtonItem(image: addIconNoBadge, style: .Plain, target: self, action: #selector(ConnectionsViewController.addConnections))
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
        
        
        searchBar.delegate = self

    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "connections"
        
        if revealViewController() != nil {
            menuItem.target = revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        connectionsModel.fetchConnections({ connections in
            dispatch_async(dispatch_get_main_queue(),{
                self.tableView.reloadData()
                
            })

        })
        
        connectionsModel.fetchAllRequests({ withRequest in
            if(withRequest) {
                
                if self.connectionsModel.numberOfRequests > 0 {
                    self.tabBarController?.tabBar.items![0].badgeValue = String(self.connectionsModel.numberOfRequests)
                }


                self.navigationItem.rightBarButtonItems![0].image = self.addIconWithBadge
            }else {
                self.navigationItem.rightBarButtonItems![0].image = self.addIconNoBadge
                
                self.tabBarController?.tabBar.items![0].badgeValue = nil

            }
        })
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if searchIsBarOpen {
            didCancelSearch()
        }
        
        if revealViewController() != nil {
            menuItem.target = nil
            menuItem.action = nil
            self.view.removeGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        connectionsModel.connections.removeAll()
    }
    
    
    // MARK: - Life cycle
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        
//        
//        if segue.identifier  == "showConnection" {
//            
//            if sender != nil {
//                
//                
//
//                
//
//            }
//
//        }
//    }
    

    func addNavigationItems () {
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationItem.rightBarButtonItems = [addItem, searhItem]
    }
    
    func hideNavigationItems () {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = nil
    }
    
    func showSearchBar() {
        searchIsBarOpen = true
        hideNavigationItems()
        self.navigationItem.leftBarButtonItem = backItem
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    func didCancelSearch() {
        searchIsBarOpen = false
        hideNavigationItems()
        addNavigationItems()
        self.navigationItem.titleView = nil
        
        tableView.reloadData()
    }
    
    func addConnections() {
        performSegueWithIdentifier("AddConnections", sender: nil);
    }
    



    

    @IBAction func didTapSearch(sender: AnyObject) {
        self.searchBar.backgroundColor = UIColor.blackColor()

        self.navigationItem.titleView = self.searchBar
        
    }


    
}

// MARK: - Table View
extension ConnectionsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CONNECTION_CELL_IDENTIFIER, forIndexPath: indexPath) as! ConnectionCell
        
        
        if searchIsBarOpen && searchBar.text != "" && connectionsModel.filteredConnections.count > 0 {


            cell.connection = connectionsModel.filteredConnections[indexPath.row]
            if let url = connectionsModel.filteredConnections[indexPath.row].imageURL {
                connectionsModel.displayConnectionImage(url, cell: cell)
            }
        }else {
            cell.connection = connectionsModel.connections[indexPath.row]
            
            
            if let url = connectionsModel.connections[indexPath.row].imageURL {
                connectionsModel.displayConnectionImage(url, cell: cell)
            }
        }
        
        


        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        
        let senderConnection: Connection?
        
        if searchIsBarOpen && searchBar.text != "" && connectionsModel.filteredConnections.count > 0 {
            senderConnection = connectionsModel.filteredConnections[indexPath.row]
        }else {
            senderConnection = connectionsModel.connections[indexPath.row] as Connection

        }
        
       
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        if let unwrappedUid = senderConnection!.uid {
            
            let userRef = databaseRef.child("users").child(unwrappedUid )
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
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let profileController = storyboard.instantiateViewControllerWithIdentifier("ProfileView") as? ProfileViewController
                            profileController?.user = user
                            
                            
                            self.tabBarController?.parentViewController!.addChildViewController(profileController!)
                            profileController?.view.frame =  CGRectMake(screenWidth, 0.0, screenWidth, screenHeight)
                            self.tabBarController?.parentViewController!.view.addSubview((profileController?.view)!)
                            profileController!.didMoveToParentViewController(self.tabBarController?.parentViewController)
                            
                        })
                    }
                }
                
            })
            
        }
        
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
        
        if searchIsBarOpen && searchBar.text != "" && connectionsModel.filteredConnections.count > 0 {
            return connectionsModel.filteredConnections.count
        }
        return connectionsModel.connections.count
    }
}

// MARK: - Search Controller
extension ConnectionsViewController: UISearchBarDelegate {

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
    
        
        connectionsModel.filterConnections(searchText)
        
        
        self.tableView.reloadData()
        
    }


}
