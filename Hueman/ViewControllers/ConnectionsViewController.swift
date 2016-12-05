//
//  ConnectionsViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/21/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class ConnectionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    
    var connections = [Connection]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem!.title = "connections"
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        
//        connections.append(Profile(name:"Julius Busa", image: "hulyo.jpg", topic: .RelationshipMusing))
//        connections.append(Profile(name:"Maverick Shawn Aquino", image: "hulyo.jpg", topic: .OnMyPlate))
//        connections.append(Profile(name:"Nicolette Onate", image: "hulyo.jpg", topic: .DailyHustle))
//        connections.append(Profile(name:"Camille Laurente", image: "hulyo.jpg", topic: .Health))
//        connections.append(Profile(name:"Efthemios Suyat", image: "hulyo.jpg", topic: .RayOfLight))
        
        connections.append(Connection(name: "Julius Busa", location: "New York, NY", imageURL: ""))
        connections.append(Connection(name: "Maverick Shawn Aquino", location: "New York, NY", imageURL: ""))
        connections.append(Connection(name: "Nicolette Onate", location: "New York, NY", imageURL: ""))
        connections.append(Connection(name: "Camille Laurente", location: "New York, NY", imageURL: ""))
        
        connections.append(Connection(name: "Efthemios Suyat", location: "New York, NY", imageURL: ""))
        
        
        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 20)!,NSForegroundColorAttributeName : UIColor.UIColorFromRGB(0x999999)]

        
    }
    
    // MARK: - Table View

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "connections"
        
    }
    


//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let destinationProfileController = segue.destinationViewController as? ConnectionProfileViewController {
//            
//        }
//    }
    
    
}


extension ConnectionsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CONNECTION_CELL, forIndexPath: indexPath) as! ConnectionCell
        
        cell.connection = connections[indexPath.row]
        
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
